require 'highline/import'
require 'encrypted_strings'
require 'json'
require 'net/ssh'

module MasterKeyList

  class Authentication
    def initialize()
       @authentication_file = File.join(ENV['HOME'],'credentials_list.json')
    end

    def prompt_for_list_credentials()

      credentials = {}
      credentials['credentials'] = []
      cred_data = {}
      begin
        @credential_type = ask("Enter the credential type:  ") { |q| q.echo = true }

        cred_data[@credential_type] = []
        begin
          cred = {}
          cred['username'] = ask("Enter your #{@credential_type} username:  ") { |q| q.echo = true }
          cred['password'] = ask("Enter your #{@credential_type} password:  ") { |q| q.echo = "*" }
          cred_data[@credential_type] << cred
          cred_option = ask("Do you want to enter more credentials to #{@credential_type}? Y|N") { |q| q.echo = true }
        end while cred_option =~ /y|Y|Yes|YES|YeS|YEs|yES|yes/
        credential_list_option = ask("Do you want to enter more credential types to the list? Y|N") { |q| q.echo = true }
      end while credential_list_option =~ /y|Y|Yes|YES|YeS|YEs|yES|yes/
      credentials['credentials'] << cred_data
      credentials
    end

    def get_encrypted_list_credentials(credentials)

      credentials['credentials'].each do |details|
        details.each do |cred_group, cred_details|
          cred_details.each do |cred|
            cred['password'] = cred['password'].encrypt(:symmetric, :password => 'secret_key')
          end
        end
      end
      credentials
    end

    def get_decrypted_list_credentials(credentials)
      credentials['credentials'].each do |details|
        details.each do |cred_group, cred_details|
          cred_details.each do |cred|
            begin
              cred['password'] = cred['password'].decrypt(:symmetric, :password => 'secret_key')
            rescue Exception => e
              cred['password'] = cred['password']
            end
          end
        end
      end
      credentials
    end

    def store_list_credentials(credentials)
      puts "Do you want to save the credentials to a file #{@authentication_file}? Y|N"
      answer = gets.chomp.strip.downcase

      if answer =~ /y|Y|Yes|YES|YeS|YEs|yES|yes/
          File.open(@authentication_file, "w+") do |line|
            # ... process the file
            line.print credentials.to_json
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
        #puts "Credentials file #{@authentication_file} exist."
        result = true
      else
        puts "Credentials file #{@authentication_file} does not exist."
        result = false
      end
      result
    end

    def get_stored_list_credentials()
      authentication_data = File.open(@authentication_file) { |spec_file| JSON.parse(spec_file.read) }
      authentication_data = get_decrypted_list_credentials(authentication_data)
      authentication_data
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

  end #End of Class Authentication

  # This method creates an object of the class Authentication and first checks if the creds file exists.
  # If NOT then it will ask the user to provide the credentials and store then in the file.
  # If YES then it will fetch the credentials from the file directly.
  # This method returns a hash containing the username and password in decrypted format.
  def get_credentials_list()
    auth = Authentication.new()
    result = auth.check_credentials_file_exists()
    if result
      credentials = auth.get_stored_list_credentials()
    else result
      credentials = auth.prompt_for_list_credentials()
      auth.store_list_credentials(auth.get_encrypted_list_credentials(credentials))
      credentials = auth.get_decrypted_list_credentials(credentials)
    end
    credentials
  end

  def clean_up_credentials_list()
    auth = Authentication.new()
    result = auth.check_credentials_file_exists()
    if result
      auth.delete_credential_file()
    end
  end

  def view_credentials_list()
    auth = Authentication.new()
    credentials = auth.get_all_stored_credentials()
    report= <<-EOS

Credentials List:
      EOS
    credentials['credentials'].each do |accounts_list|
      accounts_list.each do |account_name, details|
        report+= <<-EOS
  account name: #{account_name}
        EOS
        details.each do |accounts|
          accounts.each do |label,value|
            report+= <<-EOS
    #{label}: #{value}
        EOS
          end
        end
      end
    end
    report
  end

end
