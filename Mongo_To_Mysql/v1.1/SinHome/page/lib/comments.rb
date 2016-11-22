def insert_comments(mysql_client,posts_set)
	set = posts_set.clone
	puts "Insert Comments Data..."
	time_1 = Time.now
	fail_count = 0
	success_count = 0
	set.each do |doc|
		id = nil,date= nil ,message = nil,post_id = nil,user_id = nil
		if doc['doc']['comments']['data'].size > 0
			doc['doc']['comments']['data'].each do |ele|
				begin
					date = ele['created_time'].to_s[0..9]
					message = Mysql2::Client.escape(ele['message'])
					post_id = doc['_id'].split('_')[1]
					user_id = ele['from']['id']
					insert_str = "INSERT INTO comments (date,message,post_id,user_id) VALUES (\'#{date}\',\'#{message}\',#{post_id.to_i},#{user_id.to_i})"
					mysql_client.query(insert_str)
					success_count += 1
				rescue => ex
					fail_count += 1
					puts "#{ex} on doc_id : #{doc['_id']} & user_id : #{user_id}"
					next	
				end
			end
		end
	end
	time_2 = Time.now
	puts "Update data of comments OK : #{time_2-time_1}秒 : fail #{fail_count} records : success #{success_count} records"
end