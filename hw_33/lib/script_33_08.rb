# ========================================================================
# Script             =   33_08.rb
# ========================================================================
# Description     =   "Using input/output  from/to file and trollop get: 'Here are sorted (alphabetically) words: '"
# Name            =    "Iryna Vainarouskaya"
# Email             =   "vainarouskaya@gmail.com"
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
write << "Here are sorted (alphabetically) words: #{array.sort.join("")}"
end

#puts "Here are sorted (alphabetically) words: #{array.sort.join("")}"
