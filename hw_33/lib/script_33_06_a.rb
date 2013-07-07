# ========================================================================
# Script             =   33_06a.rb
# ========================================================================
# Description     =   "Using trollop and input/output from/to file get: 'The summary of the following numbers is: 7 '"
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
write << "The summary of the following numbers is: #{(array[0].to_i+array[1].to_i+array[2].to_i+array[3].to_i+array[4].to_i+array[5].to_i)/array.size}"
end
#puts "The summary of the following numbers is: #{(array[0].to_i+array[1].to_i+array[2].to_i+array[3].to_i+array[4].to_i+array[5].to_i)/array.size}"

