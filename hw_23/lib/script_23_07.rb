# ========================================================================
# Script             =   23_07.rb
# ========================================================================
# Description     =   "Using optionParser & input from json-file get : 'His name is: John Smith (or Alex More --for input7b)'"
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


sent = object["sentence"].scan(/\s[A-Z]\w+/).join(" ")

puts "His name is #{sent}"