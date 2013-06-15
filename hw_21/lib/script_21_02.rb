# ========================================================================
# Script             =   script_21_02.rb
# ========================================================================
# Description     =   "Using trollap get "My favorite fruit is: from file"
# Name            =    "Your Name"
# Email             =   "your@email.com"
# ========================================================================
 
require 'trollop'
 
opts = Trollop::options do
     opt :input, "Input File", :short => "-i", :default => $stdin
end

array = []
array = opts[:input].readlines

puts "My favorite fruit is: #{array[0].chop.chop} and #{array[1].chop} "
