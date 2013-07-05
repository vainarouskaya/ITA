# ========================================================================
# Script             =   script_28_02.rb
# ========================================================================
# Description     =   "Using optionParser and input from DB "My favorite fruit is: apple and banana"
# Name            =    "Your Name"
# Email             =   "your@email.com"
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
    
    puts "My favorite fruits are #{items[0].chop} and #{items[1].chop}"
    
    rescue Mysql::Error => e
    puts e.errno
    puts e.error
    
    ensure
    con.close if con

end