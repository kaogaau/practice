#<Encoding:UTF-8>
require '/home/kaogaau/Mongo_To_Mysql/Lee/page/lib/pages.rb'
require '/home/kaogaau/Mongo_To_Mysql/Lee/page/lib/posts.rb'
require '/home/kaogaau/Mongo_To_Mysql/Lee/page/lib/users.rb'
require '/home/kaogaau/Mongo_To_Mysql/Lee/page/lib/likes.rb'
require '/home/kaogaau/Mongo_To_Mysql/Lee/page/lib/comments.rb'
require 'mongo'
require 'mysql2'
t1 = Time.now
Mongo::Logger.logger.level = ::Logger::FATAL
mongo_client = Mongo::Client.new([ '192.168.26.180:27017' ],:database =>'fb_rawdata',:user =>'admin',:password =>'12345')
mysql_client = Mysql2::Client.new(:username => "kaogaau",:password=>'12345',:host => "localhost",:port => 3306,:database=>'fb_page')#用mysql2
puts "Setting Database..."
puts "Setting Database utf8mb4..."
mysql_client.query("SET NAMES utf8mb4")
mysql_client.query("SET FOREIGN_KEY_CHECKS = 0")
#puts "Cleaning likes..."
#mysql_client.query("Truncate Table likes")
#mysql_client.query("ALTER TABLE likes AUTO_INCREMENT = 10000")
#puts "Cleaning comments..."
#mysql_client.query("Truncate Table comments")
puts "Cleaning posts..."
mysql_client.query("Truncate Table posts")
#puts "Cleaning users..."
#mysql_client.query("Truncate Table users")
puts "Cleaning pages..."
mysql_client.query("Truncate Table pages")
puts "Insert Data..."
pages_set = mongo_client['pages'].find()
posts_set = mongo_client['posts'].find()
insert_pages(mysql_client,pages_set)
insert_posts(mysql_client,posts_set)
#insert_users(mysql_client,posts_set)
#insert_likes(mysql_client,posts_set)
#insert_comments(mysql_client,posts_set)
mysql_client.query("SET FOREIGN_KEY_CHECKS = 1")
mysql_client.close
t2 = Time.now
puts "Update Data Complicate...#{Time.at(t2-t1).utc.strftime("%H:%M:%S")}"