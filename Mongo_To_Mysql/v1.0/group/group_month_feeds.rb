#<Encoding:UTF-8>
require '/home/kaogaau/Mongo_To_Mysql/mongo_client.rb'
require 'mysql2'
require 'time'
mongo_client = mongo_client( '192.168.26.180',27017,'fb_group','admin','12345')
mysql_client = Mysql2::Client.new(:username => "kaogaau",:password=>'12345',:host => "localhost",:port => 3306,:database=>'fb_group')#用mysql2
mysql_client.query("SET NAMES utf8mb4")
mysql_client.query("delete from month_feeds")
puts "Group Month Feeds : Insert Data..."
now1 = Time.now
i = 0
mongo_client['groups'].find().each do |group|
	begin
	group_id = group['_id']
	mongo_client['feeds'].find({"group_id" => group_id}).each do |feed|
		if feed['feed_time'].to_s[0..6] == now1.to_s[0..6]
			feed_likes = 0,feed_comments = 0,feed_shares = 0
			feed_id = feed["_id"].split('_')[1]
			feed_date = feed['doc']['created_time'][0..9]	
			feed_likes = feed['doc']['likes']['summary']['total_count'] if feed['doc'].has_key?('likes')	
			feed_comments = feed['doc']['comments']['summary']['total_count'] if feed['doc'].has_key?('comments')	
			feed_shares = feed['doc']['shares']['count'] if feed['doc'].has_key?('shares')
			feed_engagement = feed_likes + feed_comments + feed_shares
		insert_str = "INSERT INTO month_feeds (feed_id,group_id,feed_date,feed_engagement,feed_likes,feed_comments,feed_shares) VALUES (#{feed_id.to_i},#{group_id.to_i},\'#{feed_date}\',#{feed_engagement},#{feed_likes},#{feed_comments},#{feed_shares})"
		insert = mysql_client.query(insert_str)
		end
	end
	rescue => ex
		i += 1
		puts ex
		next	
	end
end
now2 = Time.now
puts "Group Month Feeds : Fail #{i} Records"
puts "Group Month Feeds : 轉換完成 共耗時#{now2-now1}秒"
mysql_client.close
