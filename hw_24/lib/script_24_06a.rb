# ========================================================================
# Script             =   24_06a.rb
# ========================================================================
# Description     =   "Using optionParser & input from single json-file get: 'The summary of the following numbers is: 7 '"
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

if RUBY_PLATFORM =~ /darwin/ then
     script_name = __FILE__.split("/").to_a.last
else
     script_name = __FILE__
end


puts "The summary of the following numbers is: #{(object[script_name]["number_1"].to_i+object[script_name]["number_2"].to_i+object[script_name]["number_3"].to_i+object[script_name]["number_4"].to_i+object[script_name]["number_5"].to_i+object[script_name]["number_6"].to_i)/object[script_name].size}"

