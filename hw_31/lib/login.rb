require 'mechanize'
require 'nokogiri'
require 'json'
require 'cgi'
require 'trollop'
require_relative '../common/test_spec'
require_relative '../common/log_file'
require_relative "../common/master_key/lib/master_key"
include MasterKey
require_relative "../common/master_key/lib/master_key_list"
include MasterKeyList
include LogFile

$MODULE_DIR = File.expand_path(File.dirname(__FILE__)).gsub(/lib/, '')

class EPI_BAT_11

	attr_accessor :verbose, :debug

	def initialize(domain, page_spec_path, exitstatus, email_log, email_to_filepath, smtp_server)
		@domain = domain
    @domain = "http://#{domain}" if !domain.include?("http://")
    @verbose ||= false
		@debug ||= false
    @test_specs = TestSpec.new(page_spec_path).test_spec
    @exitstatus = exitstatus
    if @exitstatus
      @log_file = get_logfile_path()
      @email_log = email_log
      @email_to = email_to_filepath
      @test_name = File.basename($0, ".*").gsub("_", " ").split(" ").each { |word| word.capitalize! }.join(" ")
      @smtp_server = smtp_server
    end
    @report = ""
  end

  def puts_debug_message(message)
		$stderr.puts("DEBUG: #{message} ") if @debug
	end

	def puts_verbose_message(message)
		$stdout.puts("#{message}") if @verbose
  end

  def get_logfile_path()
    if !File.directory?(File.join($MODULE_DIR,'log'))
      Dir.mkdir(File.join($MODULE_DIR,'log'))
      File.chmod(0777, File.join($MODULE_DIR,'log'))
    end
    timestamp = Time.now.strftime('%Y-%m-%d-%H-%M-%S')
    file_name = "#{File.basename( __FILE__, ".*" )}-#{timestamp}.log"
    file_path = File.join($MODULE_DIR,'log',file_name)
    file_path
  end

  def get_web_page(link)
      begin
          page_data = {}
          page_data[:agent]= Mechanize.new
          page_data[:page]= page_data[:agent].get(link)
          page_data[:page].encoding = 'UTF-8'
          page_data[:body]= page_data[:page].body
          page_data[:status] = "PASS"
      rescue Exception => e
          page_data[:status] = "BLOCK: #{e.message}"
      end
      page_data
  end

  def get_clicked_page(current_page, link_text=nil, link_href=nil)
    page_data = {}
    begin
      if link_href==nil
        page_data[:page] = current_page.link_with(:text => link_text).click
      elsif link_text == nil
        page_data[:page] = current_page.link_with(:href => link_href).click
      else
        page_data[:page] = current_page.link_with(:text => link_text, :href => link_href).click
      end
      page_data[:page].encoding = 'UTF-8'
      page_data[:status] = "PASS"
    rescue Exception => e
      page_data[:status] = "BLOCK: #{e.message}"
    end
    page_data
  end

  def run()
    @credentials_list = fetch_credentials_list()
    @report += <<-EOR
#{'_'*120}
Web Server: #{@domain}
#{'_'*120}
    EOR

    puts_verbose_message("Web Page URL: #{@domain}")

      # Get the web page details
      page_data = get_web_page(@domain)
      puts_verbose_message("Web page status: #{page_data[:status]}")

      if page_data[:status] == "PASS"
        page = page_data[:page]
        agent = page_data[:agent]
        # Go to Sign In page
        page_details = get_clicked_page(page,'Sign In')

        if page_details[:status] == "PASS"
          sign_in_page = page_details[:page]
          @test_specs["test_scenarios"].each do |test_name, test_details |
            @report += <<-EOR

#{test_name}

Validations:
          EOR
            @credentials_list['credentials'].each do |accounts_list|
               case test_details["account_type"]
                  when "epi_valid"
                    accounts_list['epi_valid'].each do |accounts|
                      login_form = sign_in_page.form('login_form')
                      login_form.checkbox_with(:name => 'login_RememberInfo').check
                      login_form.login_ID = accounts["username"]
                      login_form.login_Password = accounts["password"]
                      page = agent.submit(login_form)

                      #check for user name
                      signed_in_user_account_text = "#{accounts["username"]}'s Account"

                      if page.body.include?(signed_in_user_account_text)
                        @report += <<-EOR
 PASS: For Valid credentials, message '#{signed_in_user_account_text}' is displayed : #{accounts["username"]}/#{accounts["password"]}.
                                  EOR
                      else
                        @report += <<-EOR
 FAIL: For Valid credentials, message '#{signed_in_user_account_text}' is not displayed : #{accounts["username"]}/#{accounts["password"]}
                                  EOR
                        puts_verbose_message "For Valid credentials, message '#{signed_in_user_account_text}' is not displayed : #{accounts["username"]}/#{accounts["password"]}"
                        if @exitstatus
                          File.open(@log_file, "w+"){ |file| file.print @report }
                          send_log_email(@smtp_server,@report,@test_name,@log_file,@email_to) if @email_log
                          Signal.trap('EXIT') { exit 2 }
                          exit
                        end
                      end
                      if page.body.include?(test_details['sign_out_text'])
                        @report += <<-EOR
 PASS: User '#{accounts["username"]}' has Logged In as text '#{test_details['sign_out_text']}' is displayed : #{accounts["username"]}/#{accounts["password"]}.
                                  EOR
                      else
                        @report += <<-EOR
 FAIL: User '#{accounts["username"]}' has not Logged In as text '#{test_details['sign_out_text']}' is not displayed : #{accounts["username"]}/#{accounts["password"]}
                                  EOR
                        puts_verbose_message "User #{accounts["username"]}' has not Logged In as '#{test_details['sign_out_text']}' is not displayed : #{accounts["username"]}/#{accounts["password"]}"
                        if @exitstatus
                          File.open(@log_file, "w+"){ |file| file.print @report }
                          send_log_email(@smtp_server,@report,@test_name,@log_file,@email_to) if @email_log
                          Signal.trap('EXIT') { exit 2 }
                          exit
                        end
                      end
                    end
                  when "epi_invalid_id"
                    accounts_list['epi_invalid_id'].each do |accounts|
                      login_form = sign_in_page.form('login_form')
                      login_form.checkbox_with(:name => 'login_RememberInfo').check
                      login_form.login_ID = accounts["username"]
                      login_form.login_Password = accounts["password"]
                      page = agent.submit(login_form)
                      error_message = page.parser.xpath(test_details['error_messsage_xpath']).text

                      if error_message ==  test_details['invalid_id_error']
                        @report += <<-EOR
 PASS: For Invalid ID, message '#{test_details['invalid_id_error']}' is displayed : #{accounts["username"]}/#{accounts["password"]}.
                                  EOR
                      else
                        @report += <<-EOR
 FAIL: For Invalid ID, message '#{test_details['invalid_id_error']}' is not displayed : #{accounts["username"]}/#{accounts["password"]}
       Expected: #{test_details['invalid_id_error']}
       Actual: #{error_message}
                                  EOR
                        puts_verbose_message "For Invalid ID, message '#{test_details['invalid_id_error']}' is not displayed : #{accounts["username"]}/#{accounts["password"]}"
                        if @exitstatus
                          File.open(@log_file, "w+"){ |file| file.print @report }
                          send_log_email(@smtp_server,@report,@test_name,@log_file,@email_to) if @email_log
                          Signal.trap('EXIT') { exit 2 }
                          exit
                        end
                      end
                      sign_in_page_text = page.parser.xpath("//span[@class='d-r']/b")[1].text
                      if sign_in_page_text ==  test_details['sign_in_page_text']
                        @report += <<-EOR
 PASS: The user '#{accounts["username"]}' is not Logged In, '#{test_details['sign_in_page_text']}' text is present on the page.
                                  EOR
                      else
                        @report += <<-EOR
 FAIL: The user '#{accounts["username"]}' is not on Sign In page.
       Expected: #{test_details['sign_in_page_text']}
       Actual: #{sign_in_page_text}
                                  EOR
                        puts_verbose_message "The user #{accounts["username"]} is not on Sign In page."
                        if @exitstatus
                          File.open(@log_file, "w+"){ |file| file.print @report }
                          send_log_email(@smtp_server,@report,@test_name,@log_file,@email_to) if @email_log
                          Signal.trap('EXIT') { exit 2 }
                          exit
                        end
                      end
                    end
                 when "epi_invalid_password"
                    accounts_list['epi_invalid_password'].each do |accounts|
                      login_form = sign_in_page.form('login_form')
                      login_form.checkbox_with(:name => 'login_RememberInfo').check
                      login_form.login_ID = accounts["username"]
                      login_form.login_Password = accounts["password"]
                      page = agent.submit(login_form)
                      error_message = page.parser.xpath(test_details['error_messsage_xpath']).text
                      if error_message ==  test_details['invalid_id_error']
                        @report += <<-EOR
 PASS: For Invalid password, message '#{test_details['invalid_id_error']}' is displayed : #{accounts["username"]}/#{accounts["password"]}.
                                  EOR
                      else
                        @report += <<-EOR
 FAIL: For Invalid password, message '#{test_details['invalid_id_error']}' is not displayed : #{accounts["username"]}/#{accounts["password"]}
       Expected: #{test_details['invalid_id_error']}
       Actual: #{error_message}
                                  EOR
                        puts_verbose_message "For Invalid password, message '#{test_details['invalid_id_error']}' is not displayed : #{accounts["username"]}/#{accounts["password"]}"
                        if @exitstatus
                          File.open(@log_file, "w+"){ |file| file.print @report }
                          send_log_email(@smtp_server,@report,@test_name,@log_file,@email_to) if @email_log
                          Signal.trap('EXIT') { exit 2 }
                          exit
                        end
                      end
                      sign_in_page_text = page.parser.xpath("//span[@class='d-r']/b")[1].text
                      if sign_in_page_text ==  test_details['sign_in_page_text']
                        @report += <<-EOR
 PASS: The user '#{accounts["username"]}' is not Logged In, '#{test_details['sign_in_page_text']}' text is present on the page.
                                  EOR
                      else
                        @report += <<-EOR
 FAIL: The user '#{accounts["username"]}' is not on Sign In page.
       Expected: #{test_details['sign_in_page_text']}
       Actual: #{sign_in_page_text}
                                  EOR
                        puts_verbose_message "The user #{accounts["username"]} is not on Sign In page."
                        if @exitstatus
                          File.open(@log_file, "w+"){ |file| file.print @report }
                          send_log_email(@smtp_server,@report,@test_name,@log_file,@email_to) if @email_log
                          Signal.trap('EXIT') { exit 2 }
                          exit
                        end
                      end
                    end
                 else
                   @report += <<-EOR
 BLOCK: Invalid account type provided : #{test_details["account_type"]}
                                  EOR
                   puts_verbose_message "Invalid account type provided #{test_details["account_type"]}"
                   if @exitstatus
                      File.open(@log_file, "w+"){ |file| file.print @report }
                      send_log_email(@smtp_server,@report,@test_name,@log_file,@email_to) if @email_log
                      Signal.trap('EXIT') { exit 1 }
                      exit
                   else
                     return @report
                   end
               end
            end
          end
        else
          puts_debug_message "#{page.uri} -- #{page.code}"
          @report += <<-EOR
 BLOCK: For page #{page.uri} the status code is #{page.code}

                    EOR
          puts_verbose_message "BLOCK: For page #{page.uri} the status code is #{page.code}"
          if @exitstatus
            File.open(@log_file, "w+"){ |file| file.print @report }
            send_log_email(@smtp_server,@report,@test_name,@log_file,@email_to) if @email_log
            Signal.trap('EXIT') { exit 1 }
            exit
          end
        end
      else
        puts_debug_message page_data[:status]
        @report += <<-EOR
#{page_data[:status]}

                  EOR
        puts_verbose_message "#{page_data[:status]} for #{@domain}"
        if @exitstatus
          File.open(@log_file, "w+"){ |file| file.print @report }
          send_log_email(@smtp_server,@report,@test_name,@log_file,@email_to) if @email_log
          Signal.trap('EXIT') { exit 1 }
          exit
        end
      @report += <<-EOR
#{"="*120}
      EOR
    end
    puts_verbose_message("Test completed")
    @report
  end

  def fetch_credentials_list()
    begin
      credentials = get_credentials_list()
      credentials_list = credentials
    rescue Exception => e
      @report += <<-EOR
 BLOCK:  #{e.message}
                      EOR
      puts_verbose_message "Credentials List Error: #{e.message}"
      if @exitstatus
        File.open(@log_file, "w+"){ |file| file.print @report }
        send_log_email(@smtp_server,@report,@test_name,@log_file,@email_to) if @email_log
        Signal.trap('EXIT') { exit 1 }
        exit
      else
        return @report
      end
    end
    credentials_list
  end

end

if (__FILE__ == $0)

  banner_title = File.basename($0, ".*").gsub("_", " ").split(" ").each { |word| word.capitalize! }.join(" ") + " Test"

  default_domain_servers_spec_file_path = File.join($MODULE_DIR,'etc','env_specs','domain_servers_list.json')
  default_test_spec = "#{$MODULE_DIR}etc/page_specs/login.json"
  default_output_report_file = File.join($MODULE_DIR,'reports','epi_report_tc_11.txt')

  default_email_to_filepath = "email_to.txt"

  opts = Trollop::options do
    banner <<-EOB
#{banner_title}

    #{$0} [options]

Where options are:

    EOB

    opt :domain_servers_spec, "Relative path to the file containing the domain servers", :short => "-d", :type => :string, :default => default_domain_servers_spec_file_path
    opt :test_spec, "Relative path to the test specification file ", :short => "-p", :type => :string, :default => default_test_spec
    opt :exitstatus, "Mode of execution; when enabled will exit the test if the any test fails providing the appropriate exit code", :short => "-m", :required => false
    opt :output_report_file, "The location of the output text @report file; ignored in exitstatus", :short => "-o", :type => :string, :default => default_output_report_file
    opt :verbose, "Print statements about the execution of the test during the run; ignored in exitstatus", :short => "-v", :required => false   # By default the verbose value is false
    opt :debug, "Print trace statements during the execution for debugging the test; ignored in exitstatus", :required => false   # By default the debug value is false
    opt :email_log, "Sends email with the log @report in exitstatus mode in case of a failure.", :short => "-l", :default => false
    opt :email_to, "Relative path to the file containing the to email addresses", :short => "-e", :type => :string, :default => default_email_to_filepath
    opt :smtp_server, "Provide SMTP server to be used for sending email", :type => :string, :default => 'mail.dealtime.com'
  end

  # option validation
  Trollop::die :test_spec, "test specification file (#{opts[:test_spec]}) not found" unless (File.exists?(opts[:test_spec]))
  Trollop::die :smtp_server, "SMTP server is missing" unless (opts[:smtp_server])

  server_list = Array.new
  if (opts[:domain_servers_spec])
    env_spec = TestSpec.new(opts[:domain_servers_spec]).test_spec
    env_spec["epinions_servers"].each do |server|
      server_list << server
    end
  else
    Trollop::die :domain_servers_spec, "No server or servers spec defined"
  end

  test_report = <<-EOR

Epinions - Validate Epinions.com login on all listed servers.

    EOR
  server_list.each_with_index do |server|
    epi_bat_11 = EPI_BAT_11.new(server,opts[:test_spec], opts[:exitstatus],opts[:email_log], opts[:email_to], opts[:smtp_server])
    if opts[:exitstatus] == false
      epi_bat_11.verbose = opts[:verbose]
      epi_bat_11.debug = opts[:debug]
    end

    test_report += <<-EOR
#{epi_bat_11.run()}
    EOR
  end

  if opts[:exitstatus] == false
    if opts[:output_report_file].nil? or opts[:output_report_file].empty?
      print test_report
    else
      if !File.directory?(File.join($MODULE_DIR,'reports'))
        Dir.mkdir(File.join($MODULE_DIR,'reports'))
        File.chmod(0777, File.join($MODULE_DIR,'reports'))
      end
      File.open(opts[:output_report_file], "w") do |report_file|
        report_file.print test_report
      end
    end
  end
end