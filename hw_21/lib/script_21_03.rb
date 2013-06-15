# ========================================================================
# Script             =   script_21_03.rb
# ========================================================================
# Description     =   "Using input from File and trollap get "When I am dividing 100 by 10 I am always have 10!"
# Name            =    "Your Name"
# Email             =   "your@email.com"
# ========================================================================
 
require 'trollop'
 
opts = Trollop::options do
     opt :input, "Input File", :short => "-i", :default => $stdin
end

array = []
array = opts[:input].readlines

puts "When I am dividing #{array[0].chop} by #{array[1]} I am always have #{array[0].to_i/array[1].to_i}!"

