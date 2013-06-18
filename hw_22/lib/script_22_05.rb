# ========================================================================
# Script             =   script_22_05.rb
# ========================================================================
# Description     =   "Using input from csv-file and OptionParser get "Average score of (35, 45, 61, 59 and 73) is 54.6"
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



puts "Average score of (35, 45, 61, 59 and 73) is #{(csv_file[$line_number][0].to_i+csv_file[$line_number][1].to_i+csv_file[$line_number][2].to_i+csv_file[$line_number][3].to_i+csv_file[$line_number][4].to_i)/5}"