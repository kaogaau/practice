#<Encoding:UTF-8>
require '/home/kaogaau/Mongo_To_Mysql/mongo_client.rb'
require 'mysql2'
require 'time'
mongo_client = mongo_client( '192.168.26.180',27017,'fb_group','admin','12345')
mysql_client = Mysql2::Client.new(:username => "kaogaau",:password=>'12345',:host => "localhost",:port => 3306,:database=>'fb_group')#用mysql2
mysql_client.query("SET NAMES utf8mb4")
mysql_client.query("delete from month_comments")
puts "Group Month Comments : Insert Data..."
now1 = Time.now
today = Date.today
year = today.to_s[0..3].to_i
month= today.to_s[5..6].to_i
start = Date.new(year,month,1)
day_series = start..today
i = 0
mongo_client['groups'].find().each do |group|
	begin
	group_name = nil
	group_id = group['_id']
	group_name = Mysql2::Client.escape(group['doc']['name']) if group['doc']['name']!= nil
	month_comments_hash = Hash.new(0)
	day_series.each{ |date| month_comments_hash[date.to_s] = 0}
	mongo_client['feeds'].find({"group_id" => group_id}).each do |feed|
		if feed['feed_time'].to_s[0..6] == now1.to_s[0..6]
			#group_feeds = group_feeds + 1
			month_comments_hash[feed['feed_time'].to_s[0..9]] = month_comments_hash[feed['feed_time'].to_s[0..9]] + feed['doc']['comments']['summary']['total_count'] if feed['doc'].has_key?('comments')
		#group_comments = group_comments + feed['doc']['comments']['summary']['total_count'] if feed['doc'].has_key?('comments')
		#group_shares = group_shares + feed['doc']['shares']['count'] if feed['doc'].has_key?('shares')
		end
	end
	month_comments = Array.new(0)
	month_comments_hash.each do |k,v|
		month_comments << v
	end
	#handle insert_str
	insert_str = "INSERT INTO month_comments (group_id,group_name"
	month_comments.each_with_index do |ele,index|
	insert_str = insert_str << ",day#{index+1}"
	end
	insert_str = insert_str << ") VALUES (#{group_id.to_i},\'#{group_name}\'"
	month_comments.each do |ele|
	insert_str = insert_str << ",#{ele}"
	end
	insert_str = insert_str << ")"
	################################################
	#puts insert_str
	insert = mysql_client.query(insert_str)
	rescue => ex
		i += 1
		puts ex
		next	
	end
end
now2 = Time.now
puts "Group Month Comments : Fail #{i} Records"
puts "Group Month Comments : 轉換完成 共耗時#{now2-now1}秒"
mysql_client.close
