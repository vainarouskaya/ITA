# ========================================================================
# Script             =   script_21_01.rb
# ========================================================================
# Description     =   "Using trollap get input from file "My favorite fruits are:"
# Name            =    "Your Name"
# Email             =   "your@email.com"
# ========================================================================
 
require 'trollop'
 
opts = Trollop::options do
     opt :input, "Input File", :short => "-i", :default => $stdin
end

array = []
array = opts[:input].readlines

puts "My favorite fruits are: #{array[0].chop}s and #{array[1]}s"