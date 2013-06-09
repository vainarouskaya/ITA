# ========================================================================
# Script             =   script_18_05.rb
# ========================================================================
# Description     =   "Using trollap get "Average score of (35, 45, 61, 59 and 73) is 54.6"
# Name            =    "Your Name"
# Email             =   "your@email.com"
# ========================================================================
 
require 'trollop'
 
opts = Trollop::options do
    opt :first, "first_octet", :short => "-a", :type => :float
    opt :second, "second_octet", :short => "-b", :type => :float
    opt :third, "third_octet", :short => "-c", :type => :float
    opt :fourth, "fourth_octet", :short => "-d", :type => :float
    opt :fifth, "fourth_octet", :short => "-e", :type => :float
end
 
 
puts "Average score of (35, 45, 61, 59 and 73) is #{(opts[:first]+opts[:second]+opts[:third]+opts[:fourth]+opts[:fifth])/5}"