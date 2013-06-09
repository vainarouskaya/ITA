# ========================================================================
# Script             =   17_01.rb
# ========================================================================
# Description     =   "My favorite fruits are: apples and bananas"
# Name            =    "Iryna Vainarouskaya"
# Email             =   "vainarouskaya@gmail.com"
# ========================================================================

require 'optparse'
 
OptionParser.new do |opts|
 
  opts.on("-f", "--first") do
      $a = ARGV[0]
  end
 
  opts.on("-s", "--second") do
    $b = ARGV[0]
  end
 
end.parse!
 

puts "My favorite fruits are: #{$a}s and #{$b}s"