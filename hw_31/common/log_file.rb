require 'net/smtp'

module LogFile

  def send_log_email(smtp_server,message,test_name,log_file,email_to_file_path)
      from_address = "qa_automation@ebay.com"
      to_addresses = []
      IO.readlines(File.join(File.expand_path(File.dirname(__FILE__)),email_to_file_path)).each do |id|
        val = id.gsub(/\s|\n/,'').strip
        to_addresses << val if val.match(/^[a-zA-Z0-9,!#\$%&'\*\+=\?\^_`\{\|}~-]+(\.[a-z0-9,!#\$%&'\*\+=\?\^_`\{\|}~-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.([a-z]{2,})$/)
      end
      msg = <<-MSG
From: QA Automation <qa_automation@ebay.com>
To: #{to_addresses.join(',')}
Content-Type: text/plain
Subject: #{test_name} Log Test Result

#{message}

Regards,
QA-TEAM
      MSG
      begin
        #smtp_server = 'mail.dealtime.com'
        #smtp_server = 'atom.corp.ebay.com'
        #smtp_server = 'gamail.persistent.co.in'

        Net::SMTP.start(smtp_server) do |smtp|
          smtp.send_message msg, from_address, to_addresses
        end
      rescue Exception => e
        File.open(log_file, "w+"){ |file| file.print "Exception occurred while sending the log report:\n #{e}" }
        Signal.trap('EXIT') { exit 1 }
        exit
      end
  end

end