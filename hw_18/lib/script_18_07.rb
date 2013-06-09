# ========================================================================
# Script             =   17_07.rb
# ========================================================================
# Description     =   "His name is: "
# Name            =    "Iryna Vainarouskaya"
# Email             =   "vainarouskaya@gmail.com"
# ========================================================================

require 'trollop'
 
opts = Trollop::options do
    opt :first, "first_sentence", :short => "-a", :type => :strings
  
end

array = []
array << opts[:first]

sent = array.join(" ").scan(/\s[A-Z]\w+/).join(" ")

puts "His name is #{sent}"