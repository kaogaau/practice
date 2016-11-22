#<Encoding:UTF-8>
require '/home/kaogaau/Mongo_To_Mysql/mongo_client.rb'
require 'mysql2'
require 'time'
mongo_client = mongo_client( '192.168.26.180',27017,'fb_rawdata','admin','12345')
mysql_client = Mysql2::Client.new(:username => "kaogaau",:password=>'12345',:host => "localhost",:port => 3306,:database=>'fb_page')#用mysql2
mysql_client.query("SET NAMES utf8mb4")
mysql_client.query("delete from old_fans")
puts "Insert Data..."
now1 = Time.now
i = 0
mongo_client['pages'].find().each do |page|
	begin
	page_name = nil
	page_id = page['_id']
	page_name = Mysql2::Client.escape(page['doc']['name']) if page['doc']['name']!= nil
	page_fans = page['doc']['likes']
	insert_str = "INSERT INTO pages (page_id,page_name,page_fans) VALUES (#{page_id.to_i},\'#{page_name}\',#{page_fans})"
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
