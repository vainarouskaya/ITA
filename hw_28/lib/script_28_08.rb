# ========================================================================
# Script             =   28_08.rb
# ========================================================================
# Description     =   "Using optionParser & input from DB get : Here are sorted (alphabetically) words: Fall Spring Summer Winter"
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
    


puts "Here are sorted (alphabetically) words: #{items.sort.join(" ")}"


    rescue Mysql::Error => e
    puts e.errno
    puts e.error
    
    ensure
    con.close if con

end