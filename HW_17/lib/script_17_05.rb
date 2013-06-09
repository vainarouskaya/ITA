# ========================================================================
# Script             =   17_05.rb
# ========================================================================
# Description     =   "Average score of (35, 45, 61, 59 and 73) is 54.6"
# Name            =    "Iryna Vainarouskaya"
# Email             =   "vainarouskaya@gmail.com"
# ========================================================================

require 'optparse'
 
OptionParser.new do |opts|
 
  opts.on("-f", "--first") do
      $a = ARGV[0].to_f
  end
 
  opts.on("-s", "--second") do
    $b = ARGV[0].to_f
  end
 
 opts.on("-t", "--third") do
    $c = ARGV[0].to_f
  end
  
  opts.on("--fr", "--fourth") do
    $d = ARGV[0].to_f
  end
  
   opts.on("--fv", "--fifth") do
    $e = ARGV[0].to_f
  end
  
end.parse!



puts "Average score of (35, 45, 61, 59 and 73) is #{($a+$b+$c+$d+$e)/5}"