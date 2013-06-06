BEGIN {
    name = "Iryna Vainarouskaya"
    description = "Command-line Arguments (script_13_02.rb) "
    
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

print "My favorite fruit is: "
if ARGV[0].scan(/[a-df-rt-z]s\b/).any?
  then 
  print ARGV[0].chop
  print " "
else
print ARGV[0]
end

if ARGV[1].scan(/[a-df-rt-z]s\b/).any?
  then 
  print ARGV[1].chop
else
print ARGV[1]
end
