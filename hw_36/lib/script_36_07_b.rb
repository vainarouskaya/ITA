# ========================================================================
# Script             =   36_07b.rb
# ========================================================================
# Description     =   "Using optionParser & input/output from/to DB using csv-file get : 'His name is: Alex More'"
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
    opts.on("-o", "--output") {$table_name2 = ARGV[0]}
end.parse!

begin

    con = Mysql.new 'localhost', 'auto', 'password'
    con.query("CREATE DATABASE IF NOT EXISTS #{$db_name}")
    con.query("USE #{$db_name}")
    con.query("DROP TABLE IF EXISTS #{$table_name}")
    con.query("CREATE TABLE IF NOT EXISTS #{$table_name} (Id INT PRIMARY KEY AUTO_INCREMENT, Item VARCHAR(50), TC VARCHAR(10))")
    
    ts_number = $test_case.scan(/\d+/)[0].to_i
    ts_values = CSV.read($input_file)[ts_number - 1]
    
 
    ts_values.each do |value|
        con.query("INSERT INTO #{$table_name} (Item, TC) VALUES ('#{value}', '#{$test_case}')")
    end

    
    rs = con.query(" SELECT * FROM #{$table_name}  WHERE TC = '#{$test_case}'")
    
    rs.each_hash do |row|
    items << row["Item"].chomp
    end
    
#Getting output into database
    con.query("USE #{$db_name}")
    con.query("DROP TABLE IF EXISTS #{$table_name2}")
    con.query("CREATE TABLE IF NOT EXISTS #{$table_name2} (Id INT PRIMARY KEY AUTO_INCREMENT, Item VARCHAR(150), TC VARCHAR(10))")
     
    sent = items.to_s.scan(/\s[A-Z]\w+/).join(" ")
    output = "His name is #{sent}"
    con.query("INSERT INTO #{$table_name2} (Item, TC) VALUES ('#{output}', '#{$test_case}')")

 

    rescue Mysql::Error => e
    puts e.errno
    puts e.error
    
    ensure
    con.close if con

end