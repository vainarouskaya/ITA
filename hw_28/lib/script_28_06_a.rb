# ========================================================================
# Script             =   28_06a.rb
# ========================================================================
# Description     =   "Using optionParser & input from DB get: 'Average score of (35, 45, 61, 59 and 73) is 7'"
# Name            =    "Iryna Vainarouskaya"
# Email             =   "vainarouskaya@gmail.com"
# ========================================================================
 
 
require 'optparse'
require 'mysql'

items = []

OptionParser.new do |opts|
    opts.on("-i", "--input") {$sql_file = ARGV[0]}
    opts.on("-d", "--db") {$db_name = ARGV[0]}
    opts.on("-t", "--table") {$table_name = ARGV[0]}
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
    
    rs = con.query("SELECT * FROM #{$table_name}")
    
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