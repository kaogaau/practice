require './mongo_client'
clean_count = 0
Mongo::Logger.logger.level = ::Logger::FATAL
client = mongo_client([ '192.168.26.180:27017' ],'fb_rawdata','admin','12345')
arr_no_likes = Array.new(0)
arr_no_comments = Array.new(0)
#arr_no_shares = Array.new(0)
client[:posts].find.each do |doc|
	arr_no_likes << doc['_id'] if !doc['doc'].has_key?('likes')
	arr_no_comments << doc['_id'] if !doc['doc'].has_key?('comments')
	#arr_no_shares << doc['_id'] if !doc['doc'].has_key?('shares')
end
arr_total = arr_no_likes + arr_no_comments
arr_total = arr_total.uniq
puts "Has #{arr_no_likes.size} no likes bag data"
puts "Has #{arr_no_comments.size} no comments bag data"
puts "Has #{arr_total.size} total bag data"
puts '================================='
puts 'Cleaning Data...'
puts '================================='
arr_total.each do |ele|
	result = client[:posts].find({'_id'=>ele}).delete_one
	if result.n == 1
		puts "Delet data of #{ele}"
		clean_count += 1
	end
end
puts "Cleaning #{clean_count} Data"
#puts arr_no_shares.size