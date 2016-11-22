#<Encoding:UTF-8>
require '/home/kaogaau/Mongo_To_Mysql/mongo_client.rb'
require 'mysql2'
require 'time'
mongo_client = mongo_client( '192.168.26.180',27017,'fb_rawdata','admin','12345')
mysql_client = Mysql2::Client.new(:username => "kaogaau",:password=>'12345',:host => "localhost",:port => 3306,:database=>'fb_page_test')#用mysql2
mysql_client.query("SET NAMES utf8mb4")
mysql_client.query("delete from posts")
mysql_client.query("delete from likes")
mysql_client.query("delete from comments")
mysql_client.query("delete from users")
mysql_client.query("delete from pages")
puts "delete all data"