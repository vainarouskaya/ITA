# ========================================================================
# Script             =   17_04.rb
# ========================================================================
# Description     =   "My IP Address is: 66.166.202.14 "
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
 
 opts.on("-t", "--third") do
    $c = ARGV[0]
  end
  
  opts.on("--fr", "--fourth") do
    $d = ARGV[0]
  end
  
end.parse!

puts "My IP Address is: "
ARGV.each { |z| print z, "." }