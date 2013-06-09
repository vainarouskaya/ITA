# ========================================================================
# Script             =   17_06b.rb
# ========================================================================
# Description     =   "The summary of the following numbers is: "
# Name            =    "Iryna Vainarouskaya"
# Email             =   "vainarouskaya@gmail.com"
# ========================================================================
 
require 'trollop'
 
opts = Trollop::options do
    opt :first, "first_number", :short => "-a", :type => :float
    opt :second, "second_number", :short => "-b", :type => :float
    opt :third, "third_number", :short => "-c", :type => :float
    opt :fourth, "fourth_number", :short => "-d", :type => :float
    opt :fifth, "fifth_number", :short => "-e", :type => :float
    opt :sixth, "sixth_number", :short => "-f", :type => :float
    opt :seventh, "seventh_number", :short => "-g", :type => :float
    opt :eighth, "eighth_number", :short => "-h", :type => :float
    opt :ninth, "ninth_number", :short => "-i", :type => :float
    opt :tenth, "tenth_number", :short => "-j", :type => :float
end 
 array = []
array << opts[:first]
array << opts[:second]
array << opts[:third]
array << opts[:fourth]
array << opts[:fifth]
array << opts[:sixth]
array << opts[:seventh]
array << opts[:eighth]
array << opts[:ninth]
array << opts[:tenth]

puts "The summary of the following numbers is: #{(opts[:first]+opts[:second]+opts[:third]+opts[:fourth]+opts[:fifth]+opts[:sixth]+opts[:seventh]+opts[:eighth]+opts[:ninth]+opts[:tenth])/array.size}"

