# ========================================================================
# Script             =   17_08.rb
# ========================================================================
# Description     =   "Here are sorted (alphabetically) words: "
# Name            =    "Iryna Vainarouskaya"
# Email             =   "vainarouskaya@gmail.com"
# ========================================================================


require 'trollop'
 
opts = Trollop::options do

    opt :first, "first_season", :short => "-a", :type => :string
    opt :second, "second_season", :short => "-b", :type => :string
    opt :third, "third_season", :short => "-c", :type => :string
    opt :fourth, "fourth_season", :short => "-d", :type => :string
   
end 
 array = []
array << opts[:first]
array << opts[:second]
array << opts[:third]
array << opts[:fourth]


puts "Here are sorted (alphabetically) words: #{array.sort.join(" ")}"
