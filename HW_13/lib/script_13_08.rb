BEGIN {
    name = "Iryna Vainarouskaya"
    description = "Command-line Arguments (script_13_08.rb) "
    
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

puts "Here are sorted (alphabetically) words: #{ARGV.sort{|a,b| a<=>b}.join(" ")}"