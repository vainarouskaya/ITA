# ========================================================================
# Script             =   22_08.rb
# ========================================================================
# Description     =   "Using input from csv-file and OptionParser get: 'Here are sorted (alphabetically) words: '"
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


puts "Here are sorted (alphabetically) words: #{csv_file[$line_number].sort.join(" ")}"
