# ========================================================================
# Script             =   17_02.rb
# ========================================================================
# Description     =   "My favorite fruits are: apple and banana"
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


puts "My favorite fruit is: #{$a.chop} and #{$b.chop} "
