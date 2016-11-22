#<Encoding:UTF-8>
require '/home/kaogaau/Mongo_To_Mysql/mongo_client.rb'
require 'mysql2'
require 'time'

mongo_client = mongo_client( '192.168.26.180',27017,'fb_group','admin','12345')
mysql_client = Mysql2::Client.new(:username => "kaogaau",:password=>'12345',:host => "localhost",:port => 3306,:database=>'fb_group')#用mysql2
mysql_client.query("SET NAMES utf8mb4")
mysql_client.query("delete from feeds")
puts "Group Feeds : Insert Data..."
now1 = Time.now
i = 0
mongo_client['feeds'].find().each do |doc|
begin
	 #{"_id" => "702038039868081_931196243618925"}
	 message = nil
	 status_type = nil
	 likes_count = 0
	 comments_count = 0
	 author = nil
	 feed_id = doc['_id'].split('_')[1].to_i 
	 group_id = doc['group_id'].to_i 
	 message = doc['doc']['message'] if doc['doc'].has_key?('message')
	 message = Mysql2::Client.escape(message) if message != nil
	 #message.gsub!("'","\\\\'") if message != nil
	 #message.delete!('\'')
	 created_time = doc['doc']['created_time'][0..9]+' '+doc['doc']['created_time'][11..18]
	 updated_time = doc['doc']['updated_time'][0..9]+' '+doc['doc']['updated_time'][11..18]
	 author_name = doc['doc']['from']['name']
	 author_name = Mysql2::Client.escape(author_name) if author_name != nil
	 #author.gsub!("'","\\\\'") if author != nil
	 author_id = doc['doc']['from']['id'].to_i
	 status_type = doc['doc']['status_type'] if doc['doc'].has_key?('status_type')
	 type = doc['doc']['type']
	 likes_count = doc['doc']['likes']['summary']['total_count'] if doc['doc'].has_key?('likes')
	 comments_count = doc['doc']['comments']['summary']['total_count'] if doc['doc'].has_key?('comments')
	 query_str = ""
	insert_str = "INSERT INTO feeds (feed_id,group_id,message,created_time,updated_time,author_name,author_id,status_type,type,likes_count,comments_count) VALUES (#{feed_id},#{group_id},\'#{message}\',\'#{created_time}\',\'#{updated_time}\',\'#{author_name}\',#{author_id},\'#{status_type}\',\'#{type}\',#{likes_count},#{comments_count})"
	 #p str
	 #p latest_feed_time
	 insert = mysql_client.query(insert_str)
	#puts message.encoding

rescue => ex
	i += 1
	puts ex
	puts doc['_id']
	next
end
end
now2 = Time.now
puts "Group Feeds : Fail #{i} Records"
puts "Group Feeds : 轉換完成 共耗時#{now2-now1}秒"
mysql_client.close
