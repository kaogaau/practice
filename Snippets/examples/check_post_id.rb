require './mongo_client'
Mongo::Logger.logger.level = ::Logger::FATAL
client = mongo_client([ '220.132.97.119:37017' ],'fb_rawdata','admin','12345')
post_id = Hash.new(0)
puts "Checking post_id..."
#arr_no_shares = Array.new(0)
error_data = 0
client[:posts].find.each do |doc|
	arr = doc['_id'].split('_')
	if arr[1] != nil && arr.size == 2
		post_id[arr[1]] += 1 
	else
		error_data += 1
	end
end
post_id.each do |k,v|
	puts "#{k}" if v > 1
end
puts "error data : #{error_data}"
puts "complicate"
