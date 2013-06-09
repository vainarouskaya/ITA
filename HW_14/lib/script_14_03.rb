BEGIN {
    name = "Iryna Vainarouskaya"
    description = "Command-line Arguments (script_14_03.rb). Retrieve ipv6 address from your computer "
    
    puts "####################################"
    puts "Author \s\s\s\s\s : " + name
    puts "Date \s\s\s\s\s\s\s\s: " + Time.now.to_s[0..18]
    puts ""
    puts "Ruby version : " + RUBY_VERSION
    puts "Script \s\s\s\s\s\s: " + __FILE__.chop.chop.chop
    puts "Description \s: " + description
    puts "#################################### "
    puts ""
}


if RUBY_PLATFORM =~ /32/ then
%x'ipconfig /all > ip.txt'

#Match IPv6 for Windows OS
 ipv6 = /[\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*::([\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*)?%\d{2}/
         file = File.read('ip.txt')
            match = file.match ipv6
    
 puts "IPv4 address of Windows PC: #{match}"

else
    %x'ifconfig > ip.txt'

#Match IPv4 for MAC OS   
 ipv6 = /[\dA-Fa-f]{1,4}:?(:[\dA-Fa-f]{1,4})*:([\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*)?%[\da-n]{2}/
     file = File.read('ip.txt')
        match = file.match ipv6
        puts "IPv6 address of your Mac: #{match}"
    
end 
    
    
    
    
    
   