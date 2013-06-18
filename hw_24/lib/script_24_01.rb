# ========================================================================
# Script             =   script_24_01.rb
# ========================================================================
# Description     =   "Using optionParser get input from single json-file "My favorite fruits are:"
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

puts "My favourite fruits are #{object[script_name]["fruit_a"]}s and #{object[script_name]["fruit_b"]}s"
