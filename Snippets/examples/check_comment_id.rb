require './mongo_client'
clean_count = 0
Mongo::Logger.logger.level = ::Logger::FATAL
client = mongo_client([ '192.168.26.180:27017' ],'fb_rawdata','admin','12345')
comment_id = Hash.new(0)
error_data = Hash.new(0)
puts "Checking comment_id..."
#arr_no_shares = Array.new(0)
client[:posts].find.each do |doc|
	doc['doc']['comments']['data'].each do |ele|
		arr = ele['id'].split('_')
		if arr[1] != nil && arr.size == 2
			comment_id[arr[1] ] += 1
		else
			error_data[doc['_id']] += 1
		end
	end
end
#arr = Array.new(0) 
#comment_id.each do |k,v|
#	arr << k if v > 1
#	#puts "#{k} : #{v}" if v > 1
#end
#arr = arr.uniq
#puts arr
#client[:posts].find.each do |doc|
#	doc['doc']['comments']['data'].each do |ele|
#		post_id = ele['id'].split('_')[1]
#		puts "#{doc['_id']} : #{post_id}" if arr[1] == post_id#arr.include? ele['id'].split('_')[1]
#	end
#end
#puts "double comment id : #{error_data.size}"
error_data.each do |k,v|
	result = client[:posts].find({'_id'=>k}).delete_one
	if result.n == 1
		puts "Delet data of #{k}"
		clean_count += 1
	end
end
puts "Bag data : #{error_data.size}"
puts "Cleaning #{clean_count} Data"
puts "complicate"