# ========================================================================
# Script             =   script_23_01.rb
# ========================================================================
# Description     =   "Using optionParser get input from json-file "My favorite fruits are:"
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

puts "My favourite fruits are #{object["fruit_a"]}s and #{object["fruit_b"]}s"
