# ========================================================================
# Script             =   script_22_02.rb
# ========================================================================
# Description     =   "Input from CVS-file. Get "My favorite fruit is: apple and banana"
# Name            =    "Your Name"
# Email             =   "your@email.com"
# ========================================================================
 
require 'optparse'
require 'csv'

OptionParser.new do |opts|
     opts.on("-i", "--input") do
          $file_name = ARGV[0]
     end
     
     opts.on("-l", "--line") do
          $line_number = ARGV[0].to_i-1
     end
end.parse!

     csv_file = CSV.read($file_name)

puts "My favorite fruits are: #{csv_file[$line_number][0]} and #{csv_file[$line_number][1].chop}"

