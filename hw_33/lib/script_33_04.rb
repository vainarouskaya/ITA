# ========================================================================
# Script             =   script_33_04.rb
# ========================================================================
# Description     =   "Using input/output from/to file and trollap get "My IP Address is: 20.55.444.112"
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

write << "My IP Address is: #{array[0].chop}.#{array[1].chop}.#{array[2].chop}.#{array[3]}"
end
#puts "My IP Address is: #{array[0].chop}.#{array[1].chop}.#{array[2].chop}.#{array[3]}"