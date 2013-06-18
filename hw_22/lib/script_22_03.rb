# ========================================================================
# Script             =   script_22_03.rb
# ========================================================================
# Description     =   "Using input from csv-file and optionParser get "When I am dividing 100 by 10 I am always have 10!"
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



puts "When I am dividing #{csv_file[$line_number][0]} I am always have #{csv_file[$line_number][1]}!"

