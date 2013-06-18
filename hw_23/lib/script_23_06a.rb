# ========================================================================
# Script             =   23_06a.rb
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


puts "The summary of the following numbers is: #{(object["number_1"].to_i+object["number_2"].to_i+object["number_3"].to_i+object["number_4"].to_i+object["number_5"].to_i+object["number_6"].to_i)/object.size}"

