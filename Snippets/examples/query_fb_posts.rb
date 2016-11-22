require './mongo_client'
client = mongo_client([ '192.168.26.180:27017' ],'fb_rawdata','admin','12345')
hash_likes = Hash.new(0)
hash_comments = Hash.new(0)
client[:posts].find().each do|doc|
	hash_likes[doc['_id']] = doc['doc']['likes']['summary']['total_count'] if doc['doc'].has_key?('likes') and doc['doc']['created_time'][5..6] == '07'
	hash_comments[doc['_id']] = doc['doc']['comments']['summary']['total_count'] if doc['doc'].has_key?('comments') and doc['doc']['created_time'][5..6] == '07'
end
hash_likes = hash_likes.sort_by{|k,v| -v}
hash_comments = hash_comments.sort_by{|k,v| -v}
File.open('./log/hot_likes_07.csv','w+') do |output|
	output.puts "link,likes_count"
	i = 0
	hash_likes.each do |k,v|
		i += 1
		output.puts  'https://www.facebook.com/'+"#{k},#{v}" 
		if i == 100
			break	
		end
	end
end
#puts "=====total_pages:#{hash.size}====="
#puts "=====total_posts:#{client[:posts].find.count}====="
