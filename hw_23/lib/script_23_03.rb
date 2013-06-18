# ========================================================================
# Script             =   script_23_03.rb
# ========================================================================
# Description     =   "Using optionParser & input from json-file get "When I am dividing 100 by 10 I am always have 10!"
# Name            =    "Your Name"
# Email             =   "your@email.com"
# ========================================================================
 
require 'optparse'
require 'json'
OptionParser.new do |opts|
     opts.on("-i", "--input") do
          $file_name = ARGV[0]
     end
end.parse!

json_file = File.read($file_name)
object = JSON.parse(json_file)

puts "When I am dividing #{object["int_a"]} by #{object["int_b"]} I am always have #{object["int_a"].to_i/object["int_b"].to_i}!"

