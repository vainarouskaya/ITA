# ========================================================================
# Script             =   22_06.rb
# ========================================================================
# Description     =   "Using OptionParser and input from csv-file get: 'The summary of the following numbers is: 7 '"
# Name            =    "Iryna Vainarouskaya"
# Email             =   "vainarouskaya@gmail.com"
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



puts "The summary of the following numbers is: #{(csv_file[$line_number][0].to_i+csv_file[$line_number][1].to_i+csv_file[$line_number][2].to_i+csv_file[$line_number][3].to_i+csv_file[$line_number][4].to_i+csv_file[$line_number][5].to_i)/csv_file[$line_number].size}"

