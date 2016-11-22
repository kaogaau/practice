#<Encoding:UTF-8>
require '/home/kaogaau/Mongo_To_Mysql/Lee/group/lib/groups.rb'
require '/home/kaogaau/Mongo_To_Mysql/Lee/group/lib/feeds.rb'
require '/home/kaogaau/Mongo_To_Mysql/Lee/group/lib/users.rb'
require '/home/kaogaau/Mongo_To_Mysql/Lee/group/lib/likes.rb'
require '/home/kaogaau/Mongo_To_Mysql/Lee/group/lib/comments.rb'
require 'mongo'
require 'mysql2'
t1 = Time.now
Mongo::Logger.logger.level = ::Logger::FATAL
mongo_client = Mongo::Client.new([ '192.168.26.180:27017' ],:database =>'fb_rawdata',:user =>'admin',:password =>'12345')
mysql_client = Mysql2::Client.new(:username => "kaogaau",:password=>'12345',:host => "localhost",:port => 3306,:database=>'fb_group')#用mysql2
puts "Setting Database..."
puts "Setting Database utf8mb4..."
mysql_client.query("SET NAMES utf8mb4")
mysql_client.query("SET FOREIGN_KEY_CHECKS = 0")
#puts "Cleaning likes..."
#mysql_client.query("Truncate Table likes")
#puts "Cleaning comments..."
#mysql_client.query("Truncate Table comments")
puts "Cleaning feeds..."
mysql_client.query("Truncate Table feeds")
#puts "Cleaning users..."
#mysql_client.query("Truncate Table users")
puts "Cleaning groups..."
mysql_client.query("Truncate Table groups")
puts "Insert Data..."
groups_set = mongo_client['groups'].find()
feeds_set = mongo_client['feeds'].find()
insert_groups(mysql_client,groups_set)
insert_feeds(mysql_client,feeds_set)
#insert_users(mysql_client,feeds_set)
#insert_likes(mysql_client,feeds_set)
#insert_comments(mysql_client,feeds_set)
mysql_client.query("SET FOREIGN_KEY_CHECKS = 1")
mysql_client.close
t2 = Time.now
puts "Update Data Complicate...#{t2-t1}seconds"