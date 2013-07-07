# ========================================================================
# Script             =   script_33_02.rb
# ========================================================================
# Description     =   "Using trollap, input and output from file get "My favorite fruit is: from file"
# Name            =    "Your Name"
# Email             =   "your@email.com"
# ========================================================================
 
require 'trollop'
 
opts = Trollop::options do
     opt :input, "Input File", :short => "-i", :type => :string#, :default => $stdin
     opt :output, "Output File", :short => "-o", :type => :string#, :default => $stdout
end

array = []
File.open(opts[:input],"r").each do |line|
     array << line
end

File.open(opts[:output], "w") do |write|
   write.puts "My favorite fruit is: #{array[0].to_s.chop.chop.chomp} and #{array[1].to_s.chop} "
end
