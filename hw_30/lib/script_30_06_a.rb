# ========================================================================
# Script             =   30_06a.rb
# ========================================================================
# Description     =   "Using optionParser & input from DB usig csv-file get: 'Average score of (35, 45, 61, 59 and 73) is 7'"
# Name            =    "Iryna Vainarouskaya"
# Email             =   "vainarouskaya@gmail.com"
# ========================================================================
 
 
require 'optparse'
require 'mysql'
require 'csv'


items = []


OptionParser.new do |opts|
    opts.on("-i", "--input") {$input_file = ARGV[0]}
    opts.on("-d", "--db") {$db_name = ARGV[0]}
    opts.on("-c", "--test_case") {$test_case = ARGV[0]}
    opts.on("-t", "--table") {$table_name = ARGV[0]}
end.parse!

begin

    con = Mysql.new 'localhost', 'auto', 'password'
    con.query("CREATE DATABASE IF NOT EXISTS #{$db_name}")
    con.query("USE #{$db_name}")
    con.query("DROP TABLE IF EXISTS #{$table_name}")
    con.query("CREATE TABLE IF NOT EXISTS #{$table_name} (Id INT PRIMARY KEY AUTO_INCREMENT, Item VARCHAR(50), TC VARCHAR(10));")
    
    ts_number = $test_case.scan(/\d+/)[0].to_i
    ts_values = CSV.read($input_file)[ts_number - 1]
    
 
    ts_values.each do |value|
        con.query("INSERT INTO #{$table_name} (Item, TC) VALUES ('#{value}', '#{$test_case}')")
    end

    
    rs = con.query(" SELECT * FROM #{$table_name}  WHERE TC = '#{$test_case}'")
    
    rs.each_hash do |row|
    items << row["Item"].chomp
    end
    
    puts "Average score of (35, 45, 61, 59 and 73) is #{(items[0].to_i+items[1].to_i+items[2].to_i+items[3].to_i+items[4].to_i+items[5].to_i)/items.size}"

    rescue Mysql::Error => e
    puts e.errno
    puts e.error
    
    ensure
    con.close if con

end