BEGIN {
    name = "Iryna Vainarouskaya"
    description = "ARGV (script_14_01_argv.rb). Retrieve system info from your computer "
    
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
#Retrieving info for Windows OS
re = ARGV[0]
  if re =='mac' then
        re = /([0-9a-fA-F]{2}(-|:)){5}[0-9a-fA-F]{2}/
        file = File.read('ip.txt') 
    match = file.match re
    
    puts "Mac address of your computer: #{$&}"
    
  elsif re == 'ipv4' then
    re = /\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/
    
    puts "IPv4 address of your Windows PC: #{$&[0]}"
    
  elsif re == 'ipv6' then
      re = /[\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*::([\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*)?%\d{2}/
         file = File.read('ip.txt')
            match = file.match re
    
    puts "IPv4 address of Windows PC: #{$&}"
  else
      re = /\w+/
end
  
else
    %x'ifconfig > ip.txt'
re = ARGV[0]
    
    if re =='mac' then
        re = /([0-9a-fA-F]{2}(-|:)){5}[0-9a-fA-F]{2}/
        file = File.read('ip.txt')
            match = file.match re
            puts "Mac address of your computer: #{$&}"
            
  elsif re == 'ipv4' then
    re = /\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/
    file = File.read('ip.txt')
    match =file.scan(re)
    
    puts "IPv4 address of your Mac: #{match[1]}"
    
  elsif re == 'ipv6' then
    re = /[\dA-Fa-f]{1,4}:?(:[\dA-Fa-f]{1,4})*:([\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*)?%[\da-n]{2}/
     file = File.read('ip.txt')
        match = file.match re
    puts "IPv6 address of your Mac: #{$&}"
    
    else
    re = /\w+/
  end
 
end
