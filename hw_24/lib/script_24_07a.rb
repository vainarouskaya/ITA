# ========================================================================
# Script             =   24_07a.rb
# ========================================================================
# Description     =   "Using optionParser & input from single json-file get : 'His name is: John Smith (or Alex More --for input7b)'"
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

sent = object[script_name]["sentence"].scan(/\s[A-Z]\w+/).join(" ")

puts "His name is #{sent}"