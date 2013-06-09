# ========================================================================
# Script             =   script_18_04.rb
# ========================================================================
# Description     =   "Using trollap get "My IP Address is: 20.55.444.112"
# Name            =    "Your Name"
# Email             =   "your@email.com"
# ========================================================================
 
require 'trollop'
 
opts = Trollop::options do
    opt :first, "first_octet", :short => "-a", :type => :int
    opt :second, "second_octet", :short => "-b", :type => :int
    opt :third, "third_octet", :short => "-c", :type => :int
    opt :fourth, "fourth_octet", :short => "-d", :type => :int
end
 
 puts "My IP Address is: #{opts[:first]}.#{opts[:second]}.#{opts[:third]}.#{opts[:fourth]}"