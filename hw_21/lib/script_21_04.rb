# ========================================================================
# Script             =   script_21_04.rb
# ========================================================================
# Description     =   "Using input from file and trollap get "My IP Address is: 20.55.444.112"
# Name            =    "Your Name"
# Email             =   "your@email.com"
# ========================================================================
 
require 'trollop'
 

 opts = Trollop::options do
     opt :input, "Input File", :short => "-i", :default => $stdin
end

array = []
array = opts[:input].readlines

 
puts "My IP Address is: #{array[0].chop}.#{array[1].chop}.#{array[2].chop}.#{array[3]}"