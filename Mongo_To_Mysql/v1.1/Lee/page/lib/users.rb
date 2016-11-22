def insert_users(mysql_client,posts_set)
	set = posts_set.clone
	time_1 = Time.now
	fail_count = 0
	success_count = 0
	users = Hash.new(0)
	set.each do |doc|
		begin
			if doc['doc']['likes']['data'].size > 0
				doc['doc']['likes']['data'].each do |ele|
					users[ele['id']] = Mysql2::Client.escape(ele['name'])
				end
			end
			if doc['doc']['comments']['data'].size > 0
				doc['doc']['comments']['data'].each do |ele|
					users[ele['from']['id']] = Mysql2::Client.escape(ele['from']['name'])
				end
			end
		rescue => ex
			puts ex
			next	
		end
	end
	puts "Insert Users Data...#{users.size}"
	users.each do |id,name|
		begin
			insert_str = "INSERT INTO users (id,name) VALUES (#{id.to_i},\'#{name}\')"
			mysql_client.query(insert_str)
			success_count += 1
		rescue  => e
			fail_count += 1
			puts "#{e} on user_id : #{id}"
			next
		end
	end
	time_2 = Time.now
	puts "Update data of users OK : #{time_2-time_1}秒 : fail #{fail_count} records : success #{success_count} records"
end