BEGIN {
    name = "Iryna Vainarouskaya"
    description = "Command-line Arguments (script_13_06a.rb) "
    
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




sum=0
ARGV.each do |z|
    sum += z.to_i
    
    
end

n=ARGV.length
result = sum/n
puts "The summary of the following numbers is: #{result}"
