# ========================================================================
# Script             =   script_29_04.rb
# ========================================================================
# Description     =   "Using optionParser & input from  single DB get: "My IP Address is: 20.55.444.112"
# Name            =    "Your Name"
# Email             =   "your@email.com"
# ========================================================================

require 'optparse'
require 'mysql'

items = []
$table_name = "t_29"

OptionParser.new do |opts|
    opts.on("-i", "--input") {$sql_file = ARGV[0]}
    opts.on("-d", "--db") {$db_name = ARGV[0]}
    opts.on("-c", "--test_case") {$test_case = ARGV[0]}
end.parse!

begin

    con = Mysql.new 'localhost', 'auto', 'password'
    con.query("CREATE DATABASE IF NOT EXISTS #{$db_name}")
    con.query("USE #{$db_name}")
    con.query("DROP TABLE IF EXISTS #{$table_name}")

 
    File.readlines($sql_file).each do |sql| #CREATE TABLE IF NOT EXISTS tbl ...;
    sql = sql.gsub("tbl","#{$table_name}")        #INSERT INTO tbl (Item) VALUES ('apple');
#    puts sql
    con.query("#{sql}")                     #INSERT INTO tbl (Item) VALUES ('banana');
    end
    
    rs = con.query("SELECT * FROM #{$table_name} WHERE TC = '#{$test_case}'")
    
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