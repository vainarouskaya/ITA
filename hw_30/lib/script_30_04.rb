# ========================================================================
# Script             =   script_30_04.rb
# ========================================================================
# Description     =   "Using optionParser & input from  DB using csv-file get: "My IP Address is: 20.55.444.112"
# Name            =    "Your Name"
# Email             =   "your@email.com"
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
    
    puts "My IP Address is: #{items[0]}.#{items[1]}.#{items[2]}.#{items[3]}"

    rescue Mysql::Error => e
    puts e.errno
    puts e.error
    
    ensure
    con.close if con

end