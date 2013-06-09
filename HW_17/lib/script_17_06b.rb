# ========================================================================
# Script             =   17_06b.rb
# ========================================================================
# Description     =   "The summary of the following numbers is: "
# Name            =    "Iryna Vainarouskaya"
# Email             =   "vainarouskaya@gmail.com"
# ========================================================================

require 'optparse'
 
OptionParser.new do |opts|
 
  opts.on("-a", "--first") do
      $a = ARGV[0].to_f
  end
 
  opts.on("-b", "--second") do
    $b = ARGV[0].to_f
  end
 
 opts.on("-c", "--third") do
    $c = ARGV[0].to_f
  end
  
  opts.on("-d", "--fourth") do
    $d = ARGV[0].to_f
  end
  
   opts.on("-e", "--fifth") do
    $e = ARGV[0].to_f
  end
  
  opts.on("-f", "--fifth") do
    $f = ARGV[0].to_f
  end
  opts.on("-g", "--fifth") do
    $g = ARGV[0].to_f
end

  opts.on("-h", "--fifth") do
    $h = ARGV[0].to_f
  end
  
  opts.on("-i", "--fifth") do
    $i = ARGV[0].to_f
  end
   opts.on("-j", "--fifth") do
    $j = ARGV[0].to_f
  end
  
end.parse!

sum=0
ARGV.each do |z|
    sum += z.to_f
    
    
end

n=ARGV.length
result = sum/n

  
puts "The summary of the following numbers is: #{result}"

