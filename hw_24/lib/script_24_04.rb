# ========================================================================
# Script             =   script_24_04.rb
# ========================================================================
# Description     =   "Using optionParser & input from  single json-file get: "My IP Address is: 20.55.444.112"
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
object= JSON.parse(json_file)


if RUBY_PLATFORM =~ /darwin/ then
     script_name = __FILE__.split("/").to_a.last
else
     script_name = __FILE__
end

puts "My IP Address is: #{object[script_name]["octet_1"]}.#{object[script_name]["octet_2"]}.#{object[script_name]["octet_3"]}.#{object[script_name]["octet_4"]}"