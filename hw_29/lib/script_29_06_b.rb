# ========================================================================
# Script             =   29_06b.rb
# ========================================================================
# Description     =   "Using optionParser & input from single DB get: 'Average score of (35, 45, 61, 59 and 73) is 55060.5"
# Name            =    "Iryna Vainarouskaya"
# Email             =   "vainarouskaya@gmail.com"
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
    
    puts "Average score of (35, 45, 61, 59 and 73) is #{(items[0].to_f+items[1].to_f+items[2].to_f+items[3].to_f+items[4].to_f+items[5].to_f+items[6].to_f+items[7].to_f+items[8].to_f+items[9].to_f)/items.size}"

    rescue Mysql::Error => e
    puts e.errno
    puts e.error
    
    ensure
    con.close if con

end