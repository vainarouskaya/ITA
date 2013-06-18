# ========================================================================
# Script             =   22_07.rb
# ========================================================================
# Description     =   "Using input from csv-file and OptionParser get : 'His name is: John Smith'"
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


sent = csv_file[$line_number].join(" ").scan(/\s[A-Z]\w+/).join(" ")
puts "His name is #{sent}"