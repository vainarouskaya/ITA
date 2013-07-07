# ========================================================================
# Script             =   script_33_05.rb
# ========================================================================
# Description     =   "Using input/output from/to file and trollap get "Average score of (35, 45, 61, 59 and 73) is 54.6"
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
write << "Average score of (35, 45, 61, 59 and 73) is #{(array[0].to_i+array[1].to_i+array[2].to_i+array[3].to_i+array[4].to_i)/5}"
end

#puts "Average score of (35, 45, 61, 59 and 73) is #{(array[0].to_i+array[1].to_i+array[2].to_i+array[3].to_i+array[4].to_i)/5}"