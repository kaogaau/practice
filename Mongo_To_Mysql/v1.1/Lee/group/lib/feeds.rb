def insert_feeds(mysql_client,feeds_set)
	set = feeds_set.clone
	puts "Insert feeds Data...#{set.count}"
	time_1 = Time.now
	fail_count = 0
	success_count = 0
	set.each do |doc|
		begin
			id = nil,date = nil,status_type = nil,type = nil,message = nil,likes = nil,comments = nil,shares = 0,group_id = nil,user_id = nil
			id_arr = doc['_id'].split('_')
			id = id_arr[1]
			date = doc['feed_time'].to_s[0..9]
			status_type = doc['doc']['status_type'] if doc['doc'].has_key?('status_type')
			type = doc['doc']['type'] if doc['doc'].has_key?('type')
			message = Mysql2::Client.escape(doc['doc']['message']) if doc['doc'].has_key?('message')
			likes = doc['doc']['likes']['summary']['total_count'] #if doc['doc'].has_key?('likes')
			comments = doc['doc']['comments']['summary']['total_count'] #if doc['doc'].has_key?('comments')
			shares = doc['doc']['shares']['count'] if doc['doc'].has_key?('shares')	
			group_id = id_arr[0]
			user_id = doc['doc']['from']['id']	
			insert_str = "INSERT INTO feeds (id,date,status_type,type,message,likes,comments,shares,group_id,user_id) VALUES (#{id.to_i},\'#{date}\',\'#{status_type}\',\'#{type}\',\'#{message}\',#{likes},#{comments},#{shares},#{group_id.to_i},#{user_id.to_i})"
			mysql_client.query(insert_str)
			success_count += 1
		rescue => ex
			fail_count += 1
			puts "#{ex} on doc_id : #{doc['_id']}"
			next	
		end
	end
	time_2 = Time.now
	puts "Update data of feeds OK : #{time_2-time_1}秒 : fail #{fail_count} records : success #{success_count} records"
end
