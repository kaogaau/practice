#<Encoding:UTF-8>
require '/home/kaogaau/Mongo_To_Mysql/mongo_client.rb'
require 'mysql2'
require 'time'
mongo_client = mongo_client( '192.168.26.180',27017,'fb_group','admin','12345')
mysql_client = Mysql2::Client.new(:username => "kaogaau",:password=>'12345',:host => "localhost",:port => 3306,:database=>'fb_group')#用mysql2
mysql_client.query("SET NAMES utf8mb4")
mysql_client.query("delete from groups")
puts "Group Total : Insert Data..."
now1 = Time.now
i = 0
page_data = Array.new(0)
mongo_client['groups'].find().each do |group|
	begin
	group_name = nil
	group_id = group['_id']
	group_name = Mysql2::Client.escape(group['doc']['name']) if group['doc']['name']!= nil
	if group['doc']['privacy'] == 'OPEN'
		group_privacy = 1
	else
		group_privacy = 0
	end
	#page_about = Mysql2::Client.escape(page['doc']['about']) if page['doc']['about']!= nil
	#page_fans = page['doc']['likes']
	group_likes = 0
	group_comments = 0
	group_feeds = 0
	latest_feed_time = group['latest_feed_time'].to_s[0..18]
	oldest_feed_time = group['oldest_feed_time'].to_s[0..18]
	mongo_client['feeds'].find({"group_id" => group_id}).each do |feed|
		group_likes = group_likes + feed['doc']['likes']['summary']['total_count'] if feed['doc'].has_key?('likes')
		group_comments = group_comments + feed['doc']['comments']['summary']['total_count'] if feed['doc'].has_key?('comments')
		group_feeds = group_feeds + 1
	end
	insert_str = "INSERT INTO groups (group_id,group_name,group_privacy,group_feeds,group_likes,group_comments,oldest_feed_time,latest_feed_time) VALUES (#{group_id.to_i},\'#{group_name}\',#{group_privacy},#{group_feeds},#{group_likes},#{group_comments},\'#{oldest_feed_time}\',\'#{latest_feed_time}\')"
	#page_data = [page_id,page_name,page_about,page_fans,page_likes,page_comments,page_shares]
	#p page_data
	insert = mysql_client.query(insert_str)
	rescue => ex
		i += 1
		puts ex
		next	
	end
end
now2 = Time.now
puts "Group Total : Fail #{i} Records"
puts "Group Total : 轉換完成 共耗時#{now2-now1}秒"
mysql_client.close
