BEGIN {
    name = "Iryna Vainarouskaya"
    description = "Command-line Arguments (script_15.rb). Retrieve subnet_mask from your computer "
    
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
  if  re == 'subnet_mask' then
    re = /\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/
    
    puts "IPv4 address of your Windows PC: #{$&[1]}"

  else
      re = /\w+/
end
 
  
else
    %x'ifconfig > ip.txt'
    #Retrieving info for Mac OS
    
re = ARGV[0]

    if re == 'subnet_mask' then
    re = /\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/
    file = File.read('ip.txt')
    match =file.scan(re)
    
    puts "subnet_mask of your Mac: #{match[2]}"
   
    else
    re = /\w+/
  end
 
end