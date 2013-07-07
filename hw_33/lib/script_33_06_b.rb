# ========================================================================
# Script             =   33_06b.rb
# ========================================================================
# Description     =   "Using input/output from/to file and trollop get: The summary of the following numbers is: 55060.5"
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
write << "The summary of the following numbers is: #{(array[0].to_f+array[1].to_f+array[2].to_f+array[3].to_f+array[4].to_f+array[5].to_f+array[6].to_f+array[7].to_f+array[8].to_f+array[9].to_f)/array.size}"

end

#puts "The summary of the following numbers is: #{(array[0].to_f+array[1].to_f+array[2].to_f+array[3].to_f+array[4].to_f+array[5].to_f+array[6].to_f+array[7].to_f+array[8].to_f+array[9].to_f)/array.size}"
