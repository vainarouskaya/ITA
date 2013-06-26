require 'highline/import'
require 'encrypted_strings'
require 'json'
require 'net/ssh'
require 'uri'

module MasterKeyMySQL

  class AuthenticationMKMySQL
    def initialize(file_path)
      @authentication_file = file_path
    end

    def get_host_from_url(url)
      uri = URI.parse(url)
      uri.host
    end

    def prompt_for_mysql_credentials()
      db_name = ask("Enter DB name:  ") { |q| q.echo = true }
      host = ask("Enter DB host name:  ") { |q| q.echo = true }
      username = ask("Enter DB user name:  ") { |q| q.echo = true }
      password = ask("Enter DB password:  ") { |q| q.echo = "*" }
      port = ask("Enter DB port:  ") { |q| q.echo = true }

      credentials = {}
      credentials['mysql_account'] = {}
      credentials['mysql_account']['db_name'] = db_name
      credentials['mysql_account']['host'] = host
      credentials['mysql_account']['username'] = username
      credentials['mysql_account']['password'] = password
      credentials['mysql_account']['port'] = port.to_i
      credentials
    end

    def get_encrypted_mysql_credentials(credentials)
      credentials['mysql_account']['password'] = credentials['mysql_account']['password'].encrypt(:symmetric, :password => 'secret_key')
      credentials
    end

    def get_decrypted_mysql_credentials(credentials)
      begin
        credentials['mysql_account']['password'] = credentials['mysql_account']['password'].decrypt(:symmetric, :password => 'secret_key')
      rescue Exception => e
        credentials['mysql_account']['password'] = credentials['mysql_account']['password']
      end
      credentials
    end

    def store_mysql_credentials(credentials)
      puts "Do you want to save the credentials to a file #{@authentication_file}? Y|N"
      answer = gets.chomp.strip.downcase

      if answer =~ /y|Y|Yes|YES|YeS|YEs|yES|yes/

        if check_credentials_file_exists()
          authentication_data = File.open(@authentication_file) { |spec_file| JSON.parse(spec_file.read) }
          authentication_data['mysql_account']={} if authentication_data['mysql_account'].nil?
          authentication_data['mysql_account']['username']=credentials['mysql_account']['username']
          authentication_data['mysql_account']['password']=credentials['mysql_account']['password']
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

    def get_stored_mysql_credentials()
      authentication_data = File.open(@authentication_file) { |spec_file| JSON.parse(spec_file.read) }
      authentication_data = get_decrypted_mysql_credentials(authentication_data)
      credentials = {}
      credentials['mysql_account']=authentication_data['mysql_account']
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

    def check_mysql_account_exist()
      if File.exists?(@authentication_file)
        authentication_data = File.open(@authentication_file) { |spec_file| JSON.parse(spec_file.read) }
        if !authentication_data['mysql_account'].nil?
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

  end #End of Class AuthenticationMKMySQL

  # This method creates an object of the class AuthenticationMKMySQL and first checks if the creds file exists.
  # If NOT then it will ask the user to provide the credentials and store then in the file.
  # If YES then it will fetch the credentials from the file directly.
  # This method returns a hash containing the username and password in decrypted format.
  def get_mysql_credentials(file_path)
    auth = AuthenticationMKMySQL.new(file_path)
    result = auth.check_mysql_account_exist()
    if result
      credentials = auth.get_stored_mysql_credentials()
    else result
      credentials = auth.prompt_for_mysql_credentials()
      auth.store_mysql_credentials(auth.get_encrypted_mysql_credentials(credentials))
      credentials = auth.get_decrypted_mysql_credentials(credentials)
    end
    credentials
  end

  def test_mysql_credentials(credentials)
    begin
    con = Mysql.new(credentials['host'],credentials['username'],credentials['password'],credentials['db_name'],credentials['port'])
    rescue Exception => e
      puts "Authentication invalid! #{e.message}"
      return "BLOCK"
    end
    con.close
    "PASS"
  end

  def validate_mysql_credentials(credentials,file_path)
    auth = AuthenticationMKMySQL.new(file_path)
    # Check if credentials are valid
    result = test_mysql_credentials(credentials['mysql_account'])
    if result.include?('BLOCK')
      ctr = 0
      until result.include?("PASS") || ctr == 2 do
        credentials = auth.prompt_for_mysql_credentials()
        result = test_mysql_credentials(credentials['mysql_account'])
        ctr +=1
      end
      if result.include?("PASS")
        value = auth.store_mysql_credentials(auth.get_encrypted_mysql_credentials(credentials))
        if value
           credentials = auth.get_stored_mysql_credentials()
        else
           credentials = auth.get_decrypted_mysql_credentials(credentials)
        end
      else
        credentials = result
      end
    end
    credentials
  end

  def clean_up_mysql_credentials(file_path)
    auth = AuthenticationMKMySQL.new(file_path)
    result = auth.check_credentials_file_exists()
    if result
      auth.delete_credential_file()
    end
  end

  def view_mysql_credentials(file_path)
    auth = AuthenticationMKMySQL.new(file_path)
    if auth.check_credentials_file_exists()
      credentials = auth.get_all_stored_credentials()
      report = <<-EOS
#{'mysql_account'.gsub('_',' ').capitalize}:

          EOS
      credentials['mysql_account'].each do |label, value|
        report+= <<-EOS
    #{label}: #{value}
          EOS
      end
    end
    report
  end

end
