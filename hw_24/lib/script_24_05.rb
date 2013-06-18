# ========================================================================
# Script             =   script_24_05.rb
# ========================================================================
# Description     =   "Using optionParser & input from single json-file get "Average score of (35, 45, 61, 59 and 73) is 54.6"
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

if RUBY_PLATFORM =~ /darwin/ then
     script_name = __FILE__.split("/").to_a.last
else
     script_name = __FILE__
end

 
puts "Average score of (35, 45, 61, 59 and 73) is #{(object[script_name]["number_1"].to_f+object[script_name]["number_2"].to_f+object[script_name]["number_3"].to_f+object[script_name]["number_4"].to_f+object[script_name]["number_5"].to_f)/5}"