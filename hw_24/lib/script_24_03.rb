# ========================================================================
# Script             =   script_24_03.rb
# ========================================================================
# Description     =   "Using optionParser & input from single json-file get "When I am dividing 100 by 10 I am always have 10!"
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


puts "When I am dividing #{object[script_name]["int_a"]} by #{object[script_name]["int_b"]} I am always have #{object[script_name]["int_a"].to_i/object[script_name]["int_b"].to_i}!"

