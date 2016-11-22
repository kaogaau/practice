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
list = ['Birdcall','Edu_teachter','IaCA_cheap','IaCA_events','IaCA_house','IaCA_insurance','IaCA_workplace','Man_543','Man_newhand','Man_understand','Novel','Talk','Waitbird','pregnant']
list.each do |table|
	puts "#{table}..."
mongo_client["#{table}"].find().each do |doc|
	 #{"_id" => "649771145098829_885949431480998"}
	 #puts doc['doc']['post_time'].size
	 begin
	 if  doc['doc']['post_time'].size < 20 and doc['doc']['response'].size > 0
		response_id = nil,post_id = nil,response_author = nil,response_time = nil,response_content = nil
		post_id = doc['_id']
		doc['doc']['response'].each do |k,v|
			response_id = post_id.to_s + '_' + k
			response_author = Mysql2::Client.escape(v['response_author']) if v['response_author']!= nil
			response_time = v['response_time']
			response_content = Mysql2::Client.escape(v['response_content']) if v['response_content']!= nil
			insert_str = "INSERT INTO responses (response_id,post_id,response_author,response_time,response_content) VALUES (\'#{response_id}\',\'#{post_id}\',\'#{response_author}\',\'#{response_time}\',\'#{response_content}\')"
			insert = mysql_client.query(insert_str)
		end
	end
	rescue => ex
		i += 1
		puts ex
		#puts "#{doc['_id']}"
		next
	 	
	end		
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
