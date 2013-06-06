BEGIN {
    name = "Iryna Vainarouskaya"
    description = "Command-line Arguments (script_13_05.rb) "
    
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
c=ARGV[2].to_i
d=ARGV[3].to_i
e=ARGV[4].to_i

avr=(a+b+c+d+e)/5.to_f

puts "Average score of (35, 45, 61, 59 and 73) is #{avr}"
