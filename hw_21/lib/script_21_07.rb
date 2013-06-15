# ========================================================================
# Script             =   21_07.rb
# ========================================================================
# Description     =   "Using input from file get : 'His name is: John Smith'"
# Name            =    "Iryna Vainarouskaya"
# Email             =   "vainarouskaya@gmail.com"
# ========================================================================

require 'trollop'

 opts = Trollop::options do
     opt :input, "Input File", :short => "-i", :default => $stdin
end

array = []
array = opts[:input].readlines


sent = array.join(" ").scan(/\s[A-Z]\w+/).join(" ")

puts "His name is #{sent}"