require 'highline/import'
require 'encrypted_strings'
require 'json'
require 'net/ssh'

module MasterKeyWindows

  class Authentication
    def initialize()
       @authentication_file = File.join(ENV['HOME'],'credentials.json')
    end

    def prompt_for_windows_credentials()
      @acc_name = ask("Enter your windows account name:  ") { |q| q.echo = true }
      @username = ask("Enter your windows username:  ") { |q| q.echo = true }
      @password = ask("Enter your windows password:  ") { |q| q.echo = "*" }

      credentials = {}
      credentials['windows_accounts'] = {}
      credentials['windows_accounts'][@acc_name] = {}
      credentials['windows_accounts'][@acc_name]['username'] = @username
      credentials['windows_accounts'][@acc_name]['password'] = @password

      credentials
    end

    def get_encrypted_windows_credentials(credentials)
        credentials['windows_accounts'].each do |acc_name, cred|
          credentials['windows_accounts'][acc_name]['password'] = credentials['windows_accounts'][acc_name]['password'].encrypt(:symmetric, :password => 'secret_key')
        end
      credentials
    end

    def get_decrypted_windows_credentials(credentials)
      credentials['windows_accounts'].each do |acc_name, cred|
        begin
          credentials['windows_accounts'][acc_name]['password'] = credentials['windows_accounts'][acc_name]['password'].decrypt(:symmetric, :password => 'secret_key')
        rescue Exception => e
          credentials['windows_accounts'][acc_name]['password'] = credentials['windows_accounts'][acc_name]['password']
        end
      end
      credentials
    end

    def store_windows_credentials(credentials)
      puts "Do you want to save the credentials to a file #{@authentication_file}? Y|N"
      answer = gets.chomp.strip.downcase

      if answer =~ /y|Y|Yes|YES|YeS|YEs|yES|yes/

        if File.exists?(@authentication_file)
          authentication_data = File.open(@authentication_file) { |spec_file| JSON.parse(spec_file.read) }
          authentication_data['windows_accounts']={} if authentication_data['windows_accounts'].nil?
          credentials['windows_accounts'].each do |acc_name, cred|
            authentication_data['windows_accounts'][acc_name] = {} if authentication_data['windows_accounts'][acc_name].nil?
            authentication_data['windows_accounts'][acc_name]['username']=credentials['windows_accounts'][acc_name]['username']
            authentication_data['windows_accounts'][acc_name]['password']=credentials['windows_accounts'][acc_name]['password']
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

    def get_stored_windows_credentials()
      authentication_data = File.open(@authentication_file) { |spec_file| JSON.parse(spec_file.read) }
      if authentication_data['windows_accounts'].nil?
        credentials = prompt_for_windows_credentials()
        store_windows_credentials(get_encrypted_windows_credentials(credentials))
        credentials = get_decrypted_windows_credentials(credentials)
      else
        authentication_data = get_decrypted_windows_credentials(authentication_data)
        credentials = {}
        credentials['windows_accounts']={}
        authentication_data['windows_accounts'].each do |acc_name, cred|
            credentials['windows_accounts'][acc_name] = {} if credentials['windows_accounts'][acc_name].nil?
            credentials['windows_accounts'][acc_name]['username']=authentication_data['windows_accounts'][acc_name]['username']
            credentials['windows_accounts'][acc_name]['password']=authentication_data['windows_accounts'][acc_name]['password']
        end
      end
      credentials
    end
  end #End of Class Authentication

  # This method creates an object of the class Authentication and first checks if the creds file exists.
  # If NOT then it will ask the user to provide the credentials and store then in the file.
  # If YES then it will fetch the credentials from the file directly.
  # This method returns a hash containing the username and password in decrypted format.
  def get_windows_credentials()
    auth = Authentication.new()
    result = auth.check_credentials_file_exists()
    if result
      credentials = auth.get_stored_windows_credentials()
    else result
      credentials = auth.prompt_for_windows_credentials()
      auth.store_windows_credentials(auth.get_encrypted_windows_credentials(credentials))
      credentials = auth.get_decrypted_windows_credentials(credentials)
    end
    credentials
  end

end
