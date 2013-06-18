# ========================================================================
# Script             =   script_22_01.rb
# ========================================================================
# Description     =   "Using optionParser and input from csv-file  get "My favorite fruits are: apples and bananas"
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

puts "My favorite fruits are: #{csv_file[$line_number][0]}s and #{csv_file[$line_number][1]}s"