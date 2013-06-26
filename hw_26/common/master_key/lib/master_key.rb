require 'highline/import'
require 'encrypted_strings'
require 'json'
require 'net/ssh'
require 'uri'

module MasterKey

  class AuthenticationMK
    def initialize()
      @authentication_file = File.join(ENV['HOME'],'credentials.json')
    end

    def get_host_from_url(url)
      uri = URI.parse(url)
      uri.host
    end

    def prompt_for_cam_credentials()
      @server_username = ask("Enter your cam username:  ") { |q| q.echo = true }
      @server_password = ask("Enter your cam password:  ") { |q| q.echo = "*" }

      credentials = {}
      credentials['cam_account'] = {}
      credentials['cam_account']['username'] = @server_username
      credentials['cam_account']['password'] = @server_password
      credentials
    end

    def get_encrypted_cam_credentials(credentials)
      credentials['cam_account']['password'] = credentials['cam_account']['password'].encrypt(:symmetric, :password => 'secret_key')
      credentials
    end

    def get_decrypted_cam_credentials(credentials)
      begin
        credentials['cam_account']['password'] = credentials['cam_account']['password'].decrypt(:symmetric, :password => 'secret_key')
      rescue Exception => e
        credentials['cam_account']['password'] = credentials['cam_account']['password']
      end
      credentials
    end

    def store_cam_credentials(credentials)
      puts "Do you want to save the credentials to a file #{@authentication_file}? Y|N"
      answer = gets.chomp.strip.downcase

      if answer =~ /y|Y|Yes|YES|YeS|YEs|yES|yes/

        if check_credentials_file_exists()
          authentication_data = File.open(@authentication_file) { |spec_file| JSON.parse(spec_file.read) }
          authentication_data['cam_account']={} if authentication_data['cam_account'].nil?
          authentication_data['cam_account']['username']=credentials['cam_account']['username']
          authentication_data['cam_account']['password']=credentials['cam_account']['password']
          File.open(@authentication_file, "w+") do |line|
            # ... process the file
            line.print authentication_data.to_json
          end
        else
          File.open(@authentication_file, "w+") do |line|
            # ... process the file
            line.print credentials.to_json
          end
        end
        puts "Credentials saved to file #{@authentication_file} successfully"
        return true
      else
        puts "Credentials not saved to file #{@authentication_file}!"
        return false
      end
    end

    def store_all_credentials_without_prompt(credentials)
      File.open(@authentication_file, "w+") do |line|
        # ... process the file
        line.print credentials.to_json
      end
      puts "Credentials saved to file #{@authentication_file} successfully"
    end

    def check_credentials_file_exists()
      if File.exists?(@authentication_file)
        puts "Credentials file #{@authentication_file} exist."
        result = true
      else
        puts "Credentials file #{@authentication_file} does not exist."
        result = false
      end
      result
    end

    def get_stored_cam_credentials()
      authentication_data = File.open(@authentication_file) { |spec_file| JSON.parse(spec_file.read) }
      authentication_data = get_decrypted_cam_credentials(authentication_data)
      credentials = {}
      credentials['cam_account']=authentication_data['cam_account']
      credentials
    end

    def get_all_stored_credentials()
      authentication_data = File.open(@authentication_file) { |spec_file| JSON.parse(spec_file.read) }
      authentication_data = authentication_data
      authentication_data
    end

    def delete_credential_file()
      File.delete(@authentication_file)
      puts "The existing credentials file #{@authentication_file} deleted."
    end

    def check_cam_account_exist()
      if File.exists?(@authentication_file)
        authentication_data = File.open(@authentication_file) { |spec_file| JSON.parse(spec_file.read) }
        if !authentication_data['cam_account'].nil?
          result = true
        else
          result = false
        end
      else
        puts "Credentials file #{@authentication_file} does not exist."
        result = false
      end
      result
    end

  end #End of Class AuthenticationMK

  # This method creates an object of the class AuthenticationMK and first checks if the creds file exists.
  # If NOT then it will ask the user to provide the credentials and store then in the file.
  # If YES then it will fetch the credentials from the file directly.
  # This method returns a hash containing the username and password in decrypted format.
  def get_cam_credentials()
    auth = AuthenticationMK.new()
    result = auth.check_cam_account_exist()
    if result
      credentials = auth.get_stored_cam_credentials()
    else result
      credentials = auth.prompt_for_cam_credentials()
      auth.store_cam_credentials(auth.get_encrypted_cam_credentials(credentials))
      credentials = auth.get_decrypted_cam_credentials(credentials)
    end
    credentials
  end

  # This method connects to the host with the provided username and password and returns the result if the credentials are valid or invalid.
  # Three parameters are required by this method HOST, USERNAME and PASSWORD.
  # The HOST is the machine ip or machine name where we need to check the access.
  # The USERNAME and PASSWORD parameters contain the credentials provided by the user to be validated.
  def test_cam_credentials(host,username,password)
    begin
      Net::SSH.start( host, username, :password => password ) do|ssh|
      end
    rescue Exception => e
      puts "Authentication invalid!"
      return "BLOCK"
    end
    "PASS"
  end

  # This method is used to check if the provided credentials are valid or invalid.
  # If the credentials are invalid, then the user will be asked to re-enter the credentials.
  # The credential validation will continue till the user provides valid credentials or for at least 2 more times.
  # If the credentials are valid, then they are stored in the file depending on the user input.
  # This method returns the user credentials in decrypted format.
  def validate_cam_credentials(host, credentials)
    auth = AuthenticationMK.new()
    server_username = credentials['cam_account']['username']
    server_password = credentials['cam_account']['password']

    # Check if credentials are valid
    result = test_cam_credentials(host,server_username,server_password)
    if result.include?('BLOCK')
      ctr = 0
      until result.include?("PASS") || ctr == 2 do
        credentials = auth.prompt_for_cam_credentials()
        server_username = credentials['cam_account']['username']
        server_password = credentials['cam_account']['password']
        result = test_cam_credentials(host,server_username,server_password)
        ctr +=1
      end
      if result.include?("PASS")
        value = auth.store_cam_credentials(auth.get_encrypted_cam_credentials(credentials))
        if value
           credentials = auth.get_stored_cam_credentials()
        else
           credentials = auth.get_decrypted_cam_credentials(credentials)
        end
      else
        credentials = result
      end
    end
    credentials
  end

  def clean_up()
    auth = AuthenticationMK.new()
    result = auth.check_credentials_file_exists()
    if result
      auth.delete_credential_file()
    end
  end

  def view_credentials()
    auth = AuthenticationMK.new()
    report = ""
    if auth.check_credentials_file_exists()
      credentials = auth.get_all_stored_credentials()
      credentials.each do |credentials_type, details|
        report+= <<-EOS

#{credentials_type.gsub('_',' ').capitalize}:
        EOS
        if credentials_type == 'cam_account'
          details.each do |label,data|
            report+= <<-EOS
    #{label}: #{data}
          EOS
          end
        elsif credentials_type == 'db_accounts'
          details.each do |db_name,data|
            report+= <<-EOS

    db name: #{db_name}
            EOS
            data.each do |label,value|
      report+= <<-EOS
    #{label}: #{value}
          EOS
            end
          end
        elsif credentials_type =~ /web_accounts|linux_accounts/
          details.each do |db_name,data|
            report+= <<-EOS

    account name: #{db_name}
            EOS
            data.each do |label,value|
      report+= <<-EOS
    #{label}: #{value}
          EOS
            end
          end
        end
      end
    end
    report
  end

end
