BEGIN {
    name = "Iryna Vainarouskaya"
    description = "Command-line Arguments (script_14_02.rb). Retrieve ipv4 address from your computer "
    
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
    
#Match IPv6 for Windows OS
%x'ipconfig /all > ip.txt'

    ipv4 = /\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/ 
    file = File.read('ip.txt')
    match =file.scan(ipv4)
    
    puts "IPv4 address of your Windows PC: #{match[0]}"
 
else

#Match IPv6 for Mac OS
%x'ifconfig > ip.txt'
    
    ipv4 = /\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/
    file = File.read('ip.txt')
    match =file.scan(ipv4)
    
    puts "IPv4 address of your Mac: #{match[1]}"
    
end