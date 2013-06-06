# ========================================================================
# Script             =   17_07.rb
# ========================================================================
# Description     =   "His name is: "
# Name            =    "Iryna Vainarouskaya"
# Email             =   "vainarouskaya@gmail.com"
# ========================================================================

require 'optparse'
 
OptionParser.new do |opts|
 
  opts.on("-s", "--sentence") do
      $a = ARGV[0]
  end
 
  
  
end.parse!




puts "His name is #{ARGV.join(" ").scan(/\s[A-Z]\w+/)}"