# ========================================================================
# Script             =   script_22_04.rb
# ========================================================================
# Description     =   "Using input from csv-file and OptionParser get "My IP Address is: 20.55.444.112"
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


 
puts "My IP Address is: #{csv_file[$line_number][0]}.#{csv_file[$line_number][1]}.#{csv_file[$line_number][2]}.#{csv_file[$line_number][3]}"