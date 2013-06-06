BEGIN {
    name = "Iryna Vainarouskaya"
    description = "Command-line Arguments (script_13_03.rb) "
    
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
a=ARGV[0].to_i
b=ARGV[1].to_i

c=(a/b).to_i
puts "When I am dividing #{ARGV[0]} by #{ARGV[1]} I am always have #{c}!"