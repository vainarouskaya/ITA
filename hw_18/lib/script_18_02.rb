# ========================================================================
# Script             =   script_18_02.rb
# ========================================================================
# Description     =   "Using trollap get "My favorite fruit is:"
# Name            =    "Your Name"
# Email             =   "your@email.com"
# ========================================================================
 
require 'trollop'
 
opts = Trollop::options do
    opt :first, "first_fruit", :short => "-a", :type => :string
    opt :second, "second_fruit", :short => "-b", :type => :string
end
 


puts "My favorite fruit is: #{opts[:first].chop} and #{opts[:second].chop} "
