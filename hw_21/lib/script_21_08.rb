# ========================================================================
# Script             =   21_08.rb
# ========================================================================
# Description     =   "Using input from file and trollop get: 'Here are sorted (alphabetically) words: '"
# Name            =    "Iryna Vainarouskaya"
# Email             =   "vainarouskaya@gmail.com"
# ========================================================================


require 'trollop'

 opts = Trollop::options do
     opt :input, "Input File", :short => "-i", :default => $stdin
end

array = []
array = opts[:input].readlines

puts "Here are sorted (alphabetically) words: #{array.sort.join("")}"
