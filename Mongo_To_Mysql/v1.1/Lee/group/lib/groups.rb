def insert_groups(mysql_client,groups_set)
	puts "Insert groups Data..."
	time_1 = Time.now
	fail_count = 0
	success_count = 0
	groups_set.each do |doc|
		begin
			id = nil,name = nil,privacy = nil,oldest_feed_time = nil,latest_feed_time = nil
			id = doc['_id']
			name = Mysql2::Client.escape(doc['doc']['name'])
			privacy = Mysql2::Client.escape(doc['doc']['privacy'])
			oldest_feed_time = doc['oldest_feed_time'].to_s[0..19]
			latest_feed_time = doc['latest_feed_time'].to_s[0..19]
			insert_str = "INSERT INTO groups (id,name,privacy,oldest_feed_time,latest_feed_time) VALUES (#{id.to_i},\'#{name}\',\'#{privacy}\',\'#{oldest_feed_time}\',\'#{latest_feed_time}\')"
			mysql_client.query(insert_str)
			success_count += 1
		rescue => ex
			fail_count += 1
			puts ex
			next	
		end
	end
	time_2 = Time.now
	puts "Update data of groups OK : #{time_2-time_1}秒 : fail #{fail_count} records : success #{success_count} records"
end
