def insert_likes(mysql_client,posts_set)
	set = posts_set.clone
	puts "Insert Likes Data..."
	time_1 = Time.now
	fail_count = 0
	success_count = 0
	set.each do |doc|
		id = nil,post_id = nil,user_id = nil
		if doc['doc']['likes']['data'].size > 0
			doc['doc']['likes']['data'].each do |ele|
				begin
					post_id = doc['doc']['id'].split('_')[1]
					user_id = ele['id']
					insert_str = "INSERT INTO likes (post_id,user_id) VALUES (#{post_id.to_i},#{user_id.to_i})"
					mysql_client.query(insert_str)
					success_count += 1
				rescue => ex
					fail_count += 1
					puts "#{ex} on doc_id : #{doc['_id']} & user_id : #{ele['id']}"
					next	
				end
			end
		end
	end
	time_2 = Time.now
	puts "Update data of likes OK : #{time_2-time_1}秒 : fail #{fail_count} records : success #{success_count} records"
end