# ========================================================================
# Script             =   script_18_03.rb
# ========================================================================
# Description     =   "Using trollap get "When I am dividing 20 by 5 I am always have 4!"
# Name            =    "Your Name"
# Email             =   "your@email.com"
# ========================================================================
 
require 'trollop'
 
opts = Trollop::options do
    opt :first, "first_number", :short => "-a", :type => :int
    opt :second, "second_number", :short => "-b", :type => :int
end
 
 puts "When I am dividing #{opts[:first]} by #{opts[:second]} I am always have #{opts[:first]/opts[:second]}!"