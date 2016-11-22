#<Encoding:UTF-8>
require '/home/kaogaau/Mongo_To_Mysql/mongo_client.rb'
require 'mysql2'
require 'time'
mongo_client = mongo_client( '192.168.26.180',27017,'fb_rawdata','admin','12345')
mysql_client = Mysql2::Client.new(:username => "kaogaau",:password=>'12345',:host => "localhost",:port => 3306,:database=>'fb_page')#用mysql2
mysql_client.query("SET NAMES utf8mb4")
mysql_client.query("delete from month_shares")
puts "Insert Data..."
now1 = Time.now
today = Date.today
year = today.to_s[0..3].to_i
month= today.to_s[5..6].to_i
start = Date.new(year,month,1)
day_series = start..today
i = 0
mongo_client['pages'].find().each do |page|
	begin
	page_name = nil
	page_id = page['_id']
	page_name = Mysql2::Client.escape(page['doc']['name']) if page['doc']['name']!= nil
	month_shares_hash = Hash.new(0)
	day_series.each{ |date| month_shares_hash[date.to_s] = 0}
	mongo_client['posts'].find({"page_id" => page_id}).each do |post|
		if post['post_time'].to_s[0..6] == now1.to_s[0..6]
			#page_posts = page_posts + 1
			month_shares_hash[post['post_time'].to_s[0..9]] = month_shares_hash[post['post_time'].to_s[0..9]] + post['doc']['shares']['count'] if post['doc'].has_key?('shares')
		end
	end
	month_shares = Array.new(0)
	month_shares_hash.each do |k,v|
		month_shares << v
	end
	#handle insert_str
	insert_str = "INSERT INTO month_shares (page_id,page_name"
	month_shares.each_with_index do |ele,index|
	insert_str = insert_str << ",day#{index+1}"
	end
	insert_str = insert_str << ") VALUES (#{page_id.to_i},\'#{page_name}\'"
	month_shares.each do |ele|
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
puts "轉換完成 共耗時#{now2-now1}秒"
mysql_client.close
