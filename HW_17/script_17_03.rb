# ========================================================================
# Script             =   17_03.rb
# ========================================================================
# Description     =   "When I am dividing 100 by 10 I am always have 10!"
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


puts "When I am dividing #{$a} by #{$b} I am always have #{$a.to_i/$b.to_i}!"