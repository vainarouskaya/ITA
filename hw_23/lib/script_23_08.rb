# ========================================================================
# Script             =   23_08.rb
# ========================================================================
# Description     =   "Using optionParser & input from json-file get: 'Here are sorted (alphabetically) words: '"
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

array = []
array << object["season_a"]
array << object["season_b"]
array << object["season_c"]
array << object["season_d"]

puts "Here are sorted (alphabetically) words: #{array.sort.join(" ")}"
