# ========================================================================
# Script             =   17_08.rb
# ========================================================================
# Description     =   "Here are sorted (alphabetically) words: "
# Name            =    "Iryna Vainarouskaya"
# Email             =   "vainarouskaya@gmail.com"
# ========================================================================

require 'optparse'
 
 $array = []
 
OptionParser.new do |opts|
 
  opts.on("-f", "--first_season") do
     $array << ARGV[0]  
  end
 
 opts.on("-s", "--second_season") do
      $array << ARGV[0] 
  end
  
  opts.on("-t", "--third_season") do
      $array << ARGV[0] 
  end
  
  opts.on("--fr", "--fourth_season") do
      $array << ARGV[0] 
  end

end.parse!

puts "Here are sorted (alphabetically) words: #{$array.sort.join(" ")}"