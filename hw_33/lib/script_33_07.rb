# ========================================================================
# Script             =   33_07.rb
# ========================================================================
# Description     =   "Using input/output from/to file get : 'His name is: John Smith'"
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


sent = array.join(" ").scan(/\s[A-Z]\w+/).join(" ")

File.open(opts[:output], "w") do |write|
write << "His name is #{sent}"
end

#puts "His name is #{sent}"