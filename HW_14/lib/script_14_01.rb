BEGIN {
    name = "Iryna Vainarouskaya"
    description = "Command-line Arguments (script_14_01.rb). Retrieve Mac address from your computer "
    
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

else
    %x'ifconfig > ip.txt'
    end
    
    mac = /([0-9a-fA-F]{2}(-|:)){5}[0-9a-fA-F]{2}/  
    file = File.read('ip.txt') 
    match = file.match mac
    
    puts "Mac address of your computer: #{match}"