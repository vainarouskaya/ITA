# ========================================================================
# Script             =   script_23_05.rb
# ========================================================================
# Description     =   "Using optionParser & input from json-file get "Average score of (35, 45, 61, 59 and 73) is 54.6"
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

 
puts "Average score of (35, 45, 61, 59 and 73) is #{(object["number_1"].to_f+object["number_2"].to_f+object["number_3"].to_f+object["number_4"].to_f+object["number_5"].to_f)/5}"