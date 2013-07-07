# ========================================================================
# Script             =   script_33_03.rb
# ========================================================================
# Description     =   "Using input, output from/to File and trollap get "When I am dividing 100 by 10 I am always have 10!"
# Name            =    "Your Name"
# Email             =   "your@email.com"
# ========================================================================
 
require 'trollop'
 
opts = Trollop::options do
     opt :input, "Input File", :short => "-i", :type => :string#,  :default => $stdin
     opt :output, "Output File", :short => "-o", :type => :string#, :default => $stdout
end

array = []
File.open(opts[:input],"r").each do |line|
     array << line
end


File.open(opts[:output], "w") do |write|
#     puts "My favorite fruit is: #{array[0].to_s.chop.chop.chomp} and #{array[1].to_s.chop} "

write << "When I am dividing #{array[0].chop} by #{array[1]} I am always have #{array[0].to_i/array[1].to_i}!"
end
