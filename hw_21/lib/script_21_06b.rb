# ========================================================================
# Script             =   21_06b.rb
# ========================================================================
# Description     =   "Using input from file and trollop get: The summary of the following numbers is: 55060.5"
# Name            =    "Iryna Vainarouskaya"
# Email             =   "vainarouskaya@gmail.com"
# ========================================================================
 
require 'trollop'
 

 opts = Trollop::options do
     opt :input, "Input File", :short => "-i", :default => $stdin
end

array = []
array = opts[:input].readlines

puts "The summary of the following numbers is: #{(array[0].to_f+array[1].to_f+array[2].to_f+array[3].to_f+array[4].to_f+array[5].to_f+array[6].to_f+array[7].to_f+array[8].to_f+array[9].to_f)/array.size}"
