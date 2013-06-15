# ========================================================================
# Script             =   21_06a.rb
# ========================================================================
# Description     =   "Using trollop and input from file get: 'The summary of the following numbers is: 7 '"
# Name            =    "Iryna Vainarouskaya"
# Email             =   "vainarouskaya@gmail.com"
# ========================================================================
 
require 'trollop'
 

 opts = Trollop::options do
     opt :input, "Input File", :short => "-i", :default => $stdin
end

array = []
array = opts[:input].readlines

puts "The summary of the following numbers is: #{(array[0].to_i+array[1].to_i+array[2].to_i+array[3].to_i+array[4].to_i+array[5].to_i)/array.size}"

