# ========================================================================
# Script             =   script_21_05.rb
# ========================================================================
# Description     =   "Using input from file and trollap get "Average score of (35, 45, 61, 59 and 73) is 54.6"
# Name            =    "Your Name"
# Email             =   "your@email.com"
# ========================================================================
 
require 'trollop'
 

 opts = Trollop::options do
     opt :input, "Input File", :short => "-i", :default => $stdin
end

array = []
array = opts[:input].readlines

puts "Average score of (35, 45, 61, 59 and 73) is #{(array[0].to_i+array[1].to_i+array[2].to_i+array[3].to_i+array[4].to_i)/5}"