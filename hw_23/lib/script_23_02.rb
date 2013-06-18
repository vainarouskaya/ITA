# ========================================================================
# Script             =   script_23_02.rb
# ========================================================================
# Description     =   "Using optionParser and input from json-file "My favorite fruit is: apple and banana"
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


puts "My favorite fruit is: #{object["fruit_a"].chop} and #{object["fruit_b"].chop} "
