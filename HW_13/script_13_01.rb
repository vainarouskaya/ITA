BEGIN {
    name = "Iryna Vainarouskaya"
    description = "Command-line Arguments (script_13_01.rb) "
    
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

puts "My favorite fruits are: #{ARGV[0]+"s"+" "+"and"+" "+ARGV[1]+"s"}"