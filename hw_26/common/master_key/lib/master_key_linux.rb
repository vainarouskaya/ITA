require 'highline/import'
require 'encrypted_strings'
require 'json'
require 'net/ssh'

module MasterKeyLinux

  class Authentication
    def initialize()
       @authentication_file = File.join(ENV['HOME'],'credentials.json')
    end

    def prompt_for_linux_account(acc_name)
      puts "Enter your linux account #{acc_name} credentials:"
      @username = ask("linux username:  ") { |q| q.echo = true }
      @password = ask("linux password:  ") { |q| q.echo = "*" }

      credentials = {}
      credentials['linux_accounts'] = {}
      credentials['linux_accounts'][acc_name] = {}
      credentials['linux_accounts'][acc_name]['username'] = @username
      credentials['linux_accounts'][acc_name]['password'] = @password

      credentials
    end

    def get_encrypted_linux_credentials(credentials)
        credentials['linux_accounts'].each do |acc_name, cred|
          credentials['linux_accounts'][acc_name]['password'] = credentials['linux_accounts'][acc_name]['password'].encrypt(:symmetric, :password => 'secret_key')
        end
      credentials
    end

    def get_decrypted_linux_credentials(credentials)
      credentials['linux_accounts'].each do |acc_name, cred|
        begin
          credentials['linux_accounts'][acc_name]['password'] = credentials['linux_accounts'][acc_name]['password'].decrypt(:symmetric, :password => 'secret_key')
        rescue Exception => e
          credentials['linux_accounts'][acc_name]['password'] = credentials['linux_accounts'][acc_name]['password']
        end
      end
      credentials
    end

    def store_linux_credentials(credentials)
      puts "Do you want to save the credentials to a file #{@authentication_file}? Y|N"
      answer = gets.chomp.strip.downcase

      if answer =~ /y|Y|Yes|YES|YeS|YEs|yES|yes/

        if File.exists?(@authentication_file)
          authentication_data = File.open(@authentication_file) { |spec_file| JSON.parse(spec_file.read) }
          authentication_data['linux_accounts']={} if authentication_data['linux_accounts'].nil?
          credentials['linux_accounts'].each do |acc_name, cred|
            authentication_data['linux_accounts'][acc_name] = {} if authentication_data['linux_accounts'][acc_name].nil?
            authentication_data['linux_accounts'][acc_name]['username']=credentials['linux_accounts'][acc_name]['username']
            authentication_data['linux_accounts'][acc_name]['password']=credentials['linux_accounts'][acc_name]['password']
          end

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

    def check_linux_accounts_exists()
      if File.exists?(@authentication_file)
        authentication_data = File.open(@authentication_file) { |spec_file| JSON.parse(spec_file.read) }
        if !authentication_data['linux_accounts'].nil?
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

    def get_stored_linux_credentials()
      authentication_data = File.open(@authentication_file) { |spec_file| JSON.parse(spec_file.read) }
      authentication_data = get_decrypted_linux_credentials(authentication_data)
      credentials = {}
      credentials['linux_accounts']=authentication_data['linux_accounts']
      credentials
    end

  end #End of Class Authentication

  # This method creates an object of the class Authentication and first checks if the creds file exists with any linux accounts.
  # If NOT then it will ask the user to provide the credentials and store them in the file.
  # If YES then it will fetch the credentials from the file directly.
  #   Then it will check if the specified account name exists in the linux accounts section.
  #   If Yes then fetch the credentials.
  #   If No then ask for user inputs and save them to file.
  # This method returns a hash containing the username and password in decrypted format.
  def get_linux_account_credentials(acc_name)
    auth = Authentication.new()
    result = auth.check_linux_accounts_exists()
    if result
      credentials = auth.get_stored_linux_credentials()
      if credentials['linux_accounts'][acc_name].nil?
        credentials = auth.prompt_for_linux_account(acc_name)
        auth.store_linux_credentials(auth.get_encrypted_linux_credentials(credentials))
        credentials = auth.get_decrypted_linux_credentials(credentials)
      end
    else
      credentials = auth.prompt_for_linux_account(acc_name)
      auth.store_linux_credentials(auth.get_encrypted_linux_credentials(credentials))
      credentials = auth.get_decrypted_linux_credentials(credentials)
    end
    credentials['linux_accounts'][acc_name]
  end

  # This method connects to the host with the provided username and password and returns the result if the credentials are valid or invalid.
  # Three parameters are required by this method HOST, USERNAME and PASSWORD.
  # The HOST is the machine ip or machine name where we need to check the access.
  # The USERNAME and PASSWORD parameters contain the credentials provided by the user to be validated.
  def test_linux_credentials(host,username,password)
    begin
      Net::SSH.start( host, username, :password => password ) do|ssh|
      end
    rescue Exception => e
      puts "Authentication invalid!"
      return "BLOCK"
    end
    "PASS"
  end

  # This method is used to check if the provided credentials for a single account are valid or invalid.
  # If the credentials are invalid, then the user will be asked to re-enter the credentials.
  # The credential validation will continue till the user provides valid credentials or for at least 2 more times.
  # If the credentials are valid, then they are stored in the file depending on the user input.
  # This method returns single account the user credentials in decrypted format.
  def validate_linux_account(host, credentials, acc_name)
    auth = Authentication.new()
      server_username = credentials['username']
      server_password = credentials['password']

      # Check if credentials are valid
      result = test_linux_credentials(host,server_username,server_password)
      if result.include?('BLOCK')
        ctr = 0
        until result.include?("PASS") || ctr == 2 do
          credentials = auth.prompt_for_linux_account(acc_name)
          server_username = credentials['linux_accounts'][acc_name]['username']
          server_password = credentials['linux_accounts'][acc_name]['password']
          result = test_linux_credentials(host,server_username,server_password)
          ctr +=1
        end
        if result.include?("PASS")
          value = auth.store_linux_credentials(auth.get_encrypted_linux_credentials(credentials))
          if value
             credentials = auth.get_stored_linux_credentials()
          else
             credentials = auth.get_decrypted_linux_credentials(credentials)
          end
          credentials = credentials['linux_accounts'][acc_name]
        else
          credentials = result
        end
      end
    credentials
  end

end
