def insert_pages(mysql_client,pages_set)
	puts "Insert Pages Data..."
	time_1 = Time.now
	fail_count = 0
	success_count = 0
	pages_set.each do |doc|
		begin
			id = nil,name = nil,about = nil,old_fans = 0,new_fans = 0,oldest_datetime = nil,latest_datetime = nil
			id = doc['_id']
			name = Mysql2::Client.escape(doc['doc']['name'])
			about = Mysql2::Client.escape(doc['doc']['about']) if doc['doc'].has_key?('about')
			old_fans = doc['doc']['likes'] if time_1.to_s[8..9] == '20'
			new_fans = doc['doc']['likes']	
			#post_date = doc['doc']['created_time'][0..9]	
			oldest_datetime = doc['oldest_post_time'].to_s[0..19]
			latest_datetime = doc['latest_post_time'].to_s[0..19]
			insert_str = "INSERT INTO pages (id,name,about,old_fans,new_fans,oldest_datetime,latest_datetime) VALUES (#{id.to_i},\'#{name}\',\'#{about}\',#{old_fans},#{new_fans},\'#{oldest_datetime}\',\'#{latest_datetime}\')"
			mysql_client.query(insert_str)
			success_count += 1
		rescue => ex
			fail_count += 1
			puts ex
			next	
		end
	end
	time_2 = Time.now
	puts "Update data of pages OK : #{time_2-time_1}秒 : fail #{fail_count} records : success #{success_count} records"
end
