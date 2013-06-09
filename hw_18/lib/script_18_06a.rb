# ========================================================================
# Script             =   17_06a.rb
# ========================================================================
# Description     =   "The summary of the following numbers is: "
# Name            =    "Iryna Vainarouskaya"
# Email             =   "vainarouskaya@gmail.com"
# ========================================================================
 
require 'trollop'
 
opts = Trollop::options do
    opt :first, "first_number", :short => "-a", :type => :int
    opt :second, "second_number", :short => "-b", :type => :int
    opt :third, "third_number", :short => "-c", :type => :int
    opt :fourth, "fourth_number", :short => "-d", :type => :int
    opt :fifth, "fifth_number", :short => "-e", :type => :int
    opt :sixth, "sixth_number", :short => "-f", :type => :int
end 
 array = []
array << opts[:first]
array << opts[:second]
array << opts[:third]
array << opts[:fourth]
array << opts[:fifth]
array << opts[:sixth]

puts "The summary of the following numbers is: #{(opts[:first]+opts[:second]+opts[:third]+opts[:fourth]+opts[:fifth]+opts[:sixth])/array.size}"

