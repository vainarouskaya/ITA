# ========================================================================
# Script             =   script_18_01.rb
# ========================================================================
# Description     =   "Using trollap get "My favorite fruits are:"
# Name            =    "Your Name"
# Email             =   "your@email.com"
# ========================================================================
 
require 'trollop'
 
opts = Trollop::options do
    opt :first, "first_fruit", :short => "-a", :type => :string
    opt :second, "second_fruit", :short => "-b", :type => :string
end
 

puts "My favorite fruits are: #{opts[:first]}s and #{opts[:second]}s"