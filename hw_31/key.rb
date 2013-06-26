def get_key()
     if RUBY_PLATFORM =~ /32/ then
          mac_address =  `ipconfig /all | find "Physical Address" | find /v "00-00" `
          key = mac_address.to_s.split("\n")[0].to_s.split(":")[1].to_s.strip
      elsif RUBY_PLATFORM =~ /linux/ then
          mac_address =  `ifconfig eth0 | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}'`
          key = mac_address.to_s.strip
      elsif RUBY_PLATFORM =~ /darwin12/ then
          mac_address =  `networksetup -listallhardwareports`
          mac_address.to_s.match(/Ethernet Address: ([\w|\d]{2}(:[\w|\d]{2})+)/)
          key = $1.to_s.strip
      else
          puts "Unknown OS"
      end
          puts key
end
get_key()