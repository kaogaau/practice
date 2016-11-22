#<Encoding:UTF-8>
require '/home/kaogaau/mongo_to_mysql/mongo_client.rb'
require 'mysql2'
require 'time'
#_id = Array.new(0)
#latest_feed_time = Array.new(0)
#oldest_feed_time = Array.new(0)
#last_updated = Array.new(0)
#check_new_feeds = Array.new(0)
#check_old_feeds = Array.new(0)
#Mongo::Logger.logger.level = ::Logger::FATAL
mongo_client = mongo_client( '192.168.26.180',27017,'babyhome','admin','12345')
mysql_client = Mysql2::Client.new(:username => "kaogaau",:password=>'12345',:host => "localhost",:port => 3306,:database=>'babyhome')#用mysql2
mysql_client.query("SET NAMES utf8mb4")
#mysql_client.query("delete from comments")
puts "Insert Data..."
i = 0
mongo_client['Waitbird'].find().each do |doc|
	 #{"_id" => "649771145098829_885949431480998"}
	 begin
	post_title = nil,post_author = nil,post_time = nil,post_content = nil
	post_id = doc['_id']
	post_title = Mysql2::Client.escape(doc['doc']['title']) #if doc['doc'].has_key?('title')
	post_author = Mysql2::Client.escape(doc['doc']['post_author']) #if doc['doc'].has_key?('post_author')
	post_time = doc['doc']['post_time']
	post_content = Mysql2::Client.escape(doc['doc']['post_content']) #if doc['doc'].has_key?('post_content')
	insert_str = "INSERT INTO posts (post_id,post_title,post_author,post_time,post_content) VALUES (\'#{post_id}\',\'#{post_title}\',\'#{post_author}\',\'#{post_time}\',\'#{post_content}\')"
	#puts insert_str
	insert = mysql_client.query(insert_str)
	rescue => ex
		i += 1
		puts ex
		#puts "#{doc['_id']}"
		next
	 	
	end
end

mysql_client.close
puts "Fail #{i} Records"
puts "Insert OK"
#insert = mysql_client.query("INSERT INTO group (_id,latest_feed_time,oldest_feed_time,last_updated,check_new_feeds,check_old_feeds) VALUES (\'#{a}\',\'#{b}\')")


#rs.each do |h| 
#str = h['group_name']
#puts str.encoding
#puts str
#end
#insert = client.query ("INSERT INTO group_list (group_id, group_name) VALUES (\'#{a}\',\'#{b}\')")
#puts insert
