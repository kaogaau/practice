#<Encoding:UTF-8>
require '/home/kaogaau/Mongo_To_Mysql/mongo_client.rb'
require 'mysql2'
require 'time'

mongo_client = mongo_client( '192.168.26.180',27017,'fb_group','admin','12345')
mysql_client = Mysql2::Client.new(:username => "kaogaau",:password=>'12345',:host => "localhost",:port => 3306,:database=>'fb_group')#用mysql2
mysql_client.query("SET NAMES utf8mb4")
mysql_client.query("delete from comments")
puts "Group Feeds Comments : Insert Data..."
now1 = Time.now
i = 0
mongo_client['feeds'].find().each do |doc|
	 #{"_id" => "649771145098829_885949431480998"}
	 if doc['doc'].has_key?('comments') 
	 	if doc['doc']['comments']['data'].size > 0
	 		doc['doc']['comments']['data'].each do|hash|
	 			begin
	 			message = nil
	 			author_name = nil
	 			comment_id = hash['id'].to_i
	 			feed_id = doc['_id'].split('_')[1].to_i 
	 			group_id = doc['group_id']
	 			author_name = hash['from']['name']
	 			author_name = Mysql2::Client.escape(author_name) if author_name != nil
	 			#author.gsub!("'","\\\\'") if author != nil
	 			author_id = hash['from']['id'].to_i
	 			message = hash['message'] if hash.has_key?('message')
	 			message = Mysql2::Client.escape(message) if message != nil
	 			#message = message.escape
	 			#puts message
	 			#message.gsub!("'","\\\\'") if message != nil
	 			#message.gsub!("\\","\\\\'") if message != nil
	 			created_time = hash['created_time'][0..9]+' '+hash['created_time'][11..18]
				insert_str = "INSERT INTO comments (comment_id,feed_id,group_id,author_name,author_id,message,created_time) VALUES (#{comment_id},#{feed_id},#{group_id},\'#{author_name}\',#{author_id},\'#{message}\',\'#{created_time}\')"
				#p str
				#puts _id
				insert = mysql_client.query(insert_str)
				rescue => ex
					i += 1
					puts ex
					puts "#{doc['_id']}\t#{hash['id']}"
					next
				end
	 		end	
	 	end
	end
end
now2 = Time.now
puts "Group Feeds Comments : Fail #{i} Records"
puts "Group Feeds Comments : 轉換完成 共耗時#{now2-now1}秒"
mysql_client.close