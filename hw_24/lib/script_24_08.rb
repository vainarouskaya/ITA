# ========================================================================
# Script             =   24_08.rb
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

if RUBY_PLATFORM =~ /darwin/ then
     script_name = __FILE__.split("/").to_a.last
else
     script_name = __FILE__
end

array = []
array << object[script_name]["season_a"]
array << object[script_name]["season_b"]
array << object[script_name]["season_c"]
array << object[script_name]["season_d"]

puts "Here are sorted (alphabetically) words: #{array.sort.join(" ")}"
