require 'highline/import'
require 'encrypted_strings'
require 'json'
require 'net/ssh'

module MasterKeyWeb

  class Authentication
    def initialize()
       @authentication_file = File.join(ENV['HOME'],'credentials.json')
    end

    def prompt_for_web_account(acc_name)
      puts "Enter your web account #{acc_name} credentials:"
      @username = ask("web username:  ") { |q| q.echo = true }
      @password = ask("web password:  ") { |q| q.echo = "*" }

      credentials = {}
      credentials['web_accounts'] = {}
      credentials['web_accounts'][acc_name] = {}
      credentials['web_accounts'][acc_name]['username'] = @username
      credentials['web_accounts'][acc_name]['password'] = @password

      credentials
    end

    def get_encrypted_web_credentials(credentials)
        credentials['web_accounts'].each do |acc_name, cred|
          credentials['web_accounts'][acc_name]['password'] = credentials['web_accounts'][acc_name]['password'].encrypt(:symmetric, :password => 'secret_key')
        end
      credentials
    end

    def get_decrypted_web_credentials(credentials)
      credentials['web_accounts'].each do |acc_name, cred|
        begin
          credentials['web_accounts'][acc_name]['password'] = credentials['web_accounts'][acc_name]['password'].decrypt(:symmetric, :password => 'secret_key')
        rescue Exception => e
          credentials['web_accounts'][acc_name]['password'] = credentials['web_accounts'][acc_name]['password']
        end
      end
      credentials
    end

    def store_web_credentials(credentials)
      puts "Do you want to save the credentials to a file #{@authentication_file}? Y|N"
      answer = gets.chomp.strip.downcase

      if answer =~ /y|Y|Yes|YES|YeS|YEs|yES|yes/

        if File.exists?(@authentication_file)
          authentication_data = File.open(@authentication_file) { |spec_file| JSON.parse(spec_file.read) }
          authentication_data['web_accounts']={} if authentication_data['web_accounts'].nil?
          credentials['web_accounts'].each do |acc_name, cred|
            authentication_data['web_accounts'][acc_name] = {} if authentication_data['web_accounts'][acc_name].nil?
            authentication_data['web_accounts'][acc_name]['username']=credentials['web_accounts'][acc_name]['username']
            authentication_data['web_accounts'][acc_name]['password']=credentials['web_accounts'][acc_name]['password']
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

    def check_web_accounts_exists()
      if File.exists?(@authentication_file)
        authentication_data = File.open(@authentication_file) { |spec_file| JSON.parse(spec_file.read) }
        if !authentication_data['web_accounts'].nil?
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

    def get_stored_web_credentials()
      authentication_data = File.open(@authentication_file) { |spec_file| JSON.parse(spec_file.read) }
      authentication_data = get_decrypted_web_credentials(authentication_data)
      credentials = {}
      credentials['web_accounts']=authentication_data['web_accounts']
      credentials
    end

  end #End of Class Authentication

  # This method creates an object of the class Authentication and first checks if the creds file exists with any web accounts.
  # If NOT then it will ask the user to provide the credentials and store them in the file.
  # If YES then it will fetch the credentials from the file directly.
  #   Then it will check if the specified account name exists in the web accounts section.
  #   If Yes then fetch the credentials.
  #   If No then ask for user inputs and save them to file.
  # This method returns a hash containing the username and password in decrypted format.
  def get_web_account_credentials(acc_name)
    auth = Authentication.new()
    result = auth.check_web_accounts_exists()
    if result
      credentials = auth.get_stored_web_credentials()
      if credentials['web_accounts'][acc_name].nil?
        credentials = auth.prompt_for_web_account(acc_name)
        auth.store_web_credentials(auth.get_encrypted_web_credentials(credentials))
        credentials = auth.get_decrypted_web_credentials(credentials)
      end
    else
      credentials = auth.prompt_for_web_account(acc_name)
      auth.store_web_credentials(auth.get_encrypted_web_credentials(credentials))
      credentials = auth.get_decrypted_web_credentials(credentials)
    end
    credentials['web_accounts'][acc_name]
  end

end
