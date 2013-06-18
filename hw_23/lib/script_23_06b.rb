# ========================================================================
# Script             =   23_06b.rb
# ========================================================================
# Description     =   "Using optionParser & input from json-file get: 'The summary of the following numbers is: 7 '"
# Name            =    "Iryna Vainarouskaya"
# Email             =   "vainarouskaya@gmail.com"
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


puts "The summary of the following numbers is: #{(object["number_1"].to_f+object["number_2"].to_f+object["number_3"].to_f+object["number_4"].to_f+object["number_5"].to_f+object["number_6"].to_f+object["number_7"].to_f+object["number_8"].to_f+object["number_9"].to_f+object["number_10"].to_f)/object.size}"

