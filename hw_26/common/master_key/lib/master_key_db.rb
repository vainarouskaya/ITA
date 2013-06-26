require 'highline/import'
require 'encrypted_strings'
require 'json'
require 'net/ssh'
require 'oci8'

module MasterKeyDatabase

  class AuthenticationMKD
    def initialize()
       @authentication_file = File.join(ENV['HOME'],'credentials.json')
    end

    def prompt_for_db_credentials()

      @server_db_name = ask("Enter the database name:  ") { |q| q.echo = true }
      @server_db_service_name = ask("Enter the database #{@server_db_name} service name:  ") { |q| q.echo = true }
      @server_username = ask("Enter your database #{@server_db_name} username:  ") { |q| q.echo = true }
      @server_password = ask("Enter your database #{@server_db_name} password:  ") { |q| q.echo = "*" }

      credentials = {}
      credentials['db_accounts'] = {}
      credentials['db_accounts'][@server_db_name]= {}
      db_name = {}
      db_name['service_name'] = @server_db_service_name
      db_name['username'] = @server_username
      db_name['password'] = @server_password
      credentials['db_accounts'][@server_db_name] = db_name
      credentials
    end

    def get_encrypted_db_credentials(credentials)
      credentials['db_accounts'].each do |db_name, database_details|
        database_details['password']= database_details['password'].encrypt(:symmetric, :password => 'secret_key')
      end
      credentials
    end

    def get_decrypted_db_credentials(credentials)
      credentials['db_accounts'].each do |db_name, database_details|
        begin
          database_details['password']= database_details['password'].decrypt(:symmetric, :password => 'secret_key')
        rescue Exception => e
          database_details['password']= database_details['password']
        end
      end
      credentials
    end

    def store_db_credentials(credentials)

      @store_db_option = ask("Do you want to save the credentials to a file #{@authentication_file}? Y|N") { |q| q.echo = true }
      answer = @store_db_option.strip.downcase

      if answer =~ /y|Y|Yes|YES|YeS|YEs|yES|yes/

        if File.exists?(@authentication_file)
          authentication_data = File.open(@authentication_file) { |spec_file| JSON.parse(spec_file.read) }
          authentication_data['db_accounts']={} if authentication_data['db_accounts'].nil?

          credentials['db_accounts'].each do |db_name, details|
            if authentication_data['db_accounts'][db_name].nil?
              authentication_data['db_accounts'][db_name] = {}
              authentication_data['db_accounts'][db_name]['service_name'] = details['service_name']
              authentication_data['db_accounts'][db_name]['username'] = details['username']
              authentication_data['db_accounts'][db_name]['password'] = details['password']
            else
              authentication_data['db_accounts'][db_name]['service_name'] = details['service_name']
              authentication_data['db_accounts'][db_name]['username'] = details['username']
              authentication_data['db_accounts'][db_name]['password'] = details['password']
            end
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

    def store_db_credentials_without_prompt(credentials)
      if File.exists?(@authentication_file)
        authentication_data = File.open(@authentication_file) { |spec_file| JSON.parse(spec_file.read) }
        authentication_data['db_accounts']={} if authentication_data['db_accounts'].nil?

        credentials['db_accounts'].each do |db_name, details|
          if authentication_data['db_accounts'][db_name].nil?
            authentication_data['db_accounts'][db_name] = {}
            authentication_data['db_accounts'][db_name]['service_name'] = details['service_name']
            authentication_data['db_accounts'][db_name]['username'] = details['username']
            authentication_data['db_accounts'][db_name]['password'] = details['password']
          else
            authentication_data['db_accounts'][db_name]['service_name'] = details['service_name']
            authentication_data['db_accounts'][db_name]['username'] = details['username']
            authentication_data['db_accounts'][db_name]['password'] = details['password']
          end
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
      true
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

    def check_db_accounts_exists()
      if File.exists?(@authentication_file)
        authentication_data = File.open(@authentication_file) { |spec_file| JSON.parse(spec_file.read) }
        if !authentication_data['db_accounts'].nil?
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

    def get_stored_db_credentials()
      authentication_data = File.open(@authentication_file) { |spec_file| JSON.parse(spec_file.read) }
      authentication_data = get_decrypted_db_credentials(authentication_data) if !authentication_data['db_accounts'].nil?
      credentials = {}
      credentials['db_accounts']=authentication_data['db_accounts']
      credentials
    end

    def test_db_credentials(db_connection_string)
      begin
        conn = OCI8.new(db_connection_string)
        raise Exception if !conn =~ /#<OCI8:[0-9a-zA-Z]+>/
      rescue Exception => e
        return "BLOCK: #{e.message}"
      end
      "PASS"
    end

  end #End of Class AuthenticationMKD


  # This method checks if the db accounts are present in the credentials file.
  # If file exists and db accounts are present then gets the stored DB credentials.
  # If file does not exist then asks the user to provide the db name, service name , username and password.
  # The db connection is tested, if valid then user is asked if he/she wants to store the credentials into the file.
  # If yes, then the credentials are saved in the file else the function returns back the credentials.
  # User can manually add the db connection to the db accounts section in the file.
  # However they will not be checked when the credentials are retrieved from the file.
  def get_db_credentials()
    auth = AuthenticationMKD.new()
    result = auth.check_db_accounts_exists()
    if result
      credentials = auth.get_stored_db_credentials()
    else
      credentials = auth.prompt_for_db_credentials()
      credentials['db_accounts'].each do |db_name, database_details|
        db_connection_string = "#{database_details['username']}/#{database_details['password']}@#{database_details['service_name']}"
        result = auth.test_db_credentials(db_connection_string)
        if result.include?('BLOCK')
          ctr = 0
          until result.include?("PASS") || ctr == 2 do
            credentials = auth.prompt_for_db_credentials()
            credentials['db_accounts'].each do |name, details|
              db_connection_string = "#{details['username']}/#{details['password']}@#{details['service_name']}"
              result = auth.test_db_credentials(db_connection_string)
            end
            ctr +=1
          end
          if result.include?("PASS")
            value = auth.store_db_credentials(auth.get_encrypted_db_credentials(credentials))
            if value
               credentials = auth.get_stored_db_credentials()
            else
               credentials = auth.get_decrypted_db_credentials(credentials)
            end
          else
            credentials = result
          end
        elsif result.include?("PASS")
            value = auth.store_db_credentials(auth.get_encrypted_db_credentials(credentials))
            if value
               credentials = auth.get_stored_db_credentials()
            else
               credentials = auth.get_decrypted_db_credentials(credentials)
            end
        end
      end
    end
    credentials
  end
end
