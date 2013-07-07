# ========================================================================
# Script             =   script_33_01.rb
# ========================================================================
# Description     =   "Using trollap, input from and output to the file get "My favorite fruits are:"
# Name            =    "Your Name"
# Email             =   "your@email.com"
# ========================================================================
 
require 'trollop'
 
opts = Trollop::options do
     opt :input, "Input File", :short => "-i", :default => $stdin
     opt :output, "Output File", :short => "-o", :default => $stdout
end

array = []
array = opts[:input].readlines

File.open(opts[:output], "w") do |write|
    write << "My favorite fruits are: #{array[0].chop}s and #{array[1]}s"
end
