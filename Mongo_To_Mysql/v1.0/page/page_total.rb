#<Encoding:UTF-8>
require '/home/kaogaau/Mongo_To_Mysql/mongo_client.rb'
require 'mysql2'
require 'time'
mongo_client = mongo_client( '192.168.26.180',27017,'fb_rawdata','admin','12345')
mysql_client = Mysql2::Client.new(:username => "kaogaau",:password=>'12345',:host => "localhost",:port => 3306,:database=>'fb_page')#用mysql2
mysql_client.query("SET NAMES utf8mb4")
mysql_client.query("delete from pages")
puts "Insert Data..."
now1 = Time.now
i = 0
page_data = Array.new(0)
mongo_client['pages'].find().each do |page|
	begin
	page_name = nil,page_about = nil
	page_id = page['_id']
	page_name = Mysql2::Client.escape(page['doc']['name']) if page['doc']['name']!= nil
	page_about = Mysql2::Client.escape(page['doc']['about']) if page['doc']['about']!= nil
	page_fans = page['doc']['likes']
	page_posts = 0
	page_likes = 0
	page_comments = 0
	page_shares = 0
	latest_post_time = page['latest_post_time'].to_s[0..18]
	oldest_post_time = page['oldest_post_time'].to_s[0..18]
	mongo_client['posts'].find({"page_id" => page_id}).each do |post|
		page_posts = page_posts + 1
		page_likes = page_likes + post['doc']['likes']['summary']['total_count'] if post['doc'].has_key?('likes')
		page_comments = page_comments + post['doc']['comments']['summary']['total_count'] if post['doc'].has_key?('comments')
		page_shares = page_shares + post['doc']['shares']['count'] if post['doc'].has_key?('shares')
	end
	insert_str = "INSERT INTO pages (page_id,page_name,page_about,page_fans,page_posts,page_likes,page_comments,page_shares,oldest_post_time,latest_post_time) VALUES (#{page_id.to_i},\'#{page_name}\',\'#{page_about}\',#{page_fans},#{page_posts},#{page_likes},#{page_comments},#{page_shares},\'#{oldest_post_time}\',\'#{latest_post_time}\')"
	insert = mysql_client.query(insert_str)
	rescue => ex
		i += 1
		puts ex
		next	
	end
end
now2 = Time.now
puts "轉換完成 共耗時#{now2-now1}秒"
mysql_client.close
