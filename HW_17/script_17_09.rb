# ========================================================================
# Script             =   17_08.rb
# ========================================================================
# Description     =   "Here are sorted (alphabetically) words: "
# Name            =    "Iryna Vainarouskaya"
# Email             =   "vainarouskaya@gmail.com"
# ========================================================================

require 'optparse'
 
OptionParser.new do |opts|
 
  opts.on("-f", "--first_season") do
      $a = ARGV[0]
  end
 
 opts.on("-s", "-second_ season") do
      $b = ARGV[0]
  end
  
  opts.on("-t", "--third_ season") do
      $c = ARGV[0]
  end
  
  opts.on("--fr", "--fourth_ season") do
      $d = ARGV[0]
  end

end.parse!

puts "Here are sorted (alphabetically) words: #{ARGV.sort}"