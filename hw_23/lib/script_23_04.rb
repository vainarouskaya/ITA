# ========================================================================
# Script             =   script_23_04.rb
# ========================================================================
# Description     =   "Using optionParser & input from json-file get: "My IP Address is: 20.55.444.112"
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

 
puts "My IP Address is: #{object["octet_1"]}.#{object["octet_2"]}.#{object["octet_3"]}.#{object["octet_4"]}"