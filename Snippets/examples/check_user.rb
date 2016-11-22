require './mongo_client'
Mongo::Logger.logger.level = ::Logger::FATAL
client = mongo_client([ '192.168.26.180:27017' ],'fb_rawdata','admin','12345')
user = Hash.new{|k,v| user[v] = Array.new(0)}
puts "Checking user_id..."
############check page############
client[:posts].find().each do |doc|
	if doc['doc']['likes']['summary']['total_count'] > 0
		doc['doc']['likes']['data'].each do |ele|
			user[ele['id']] << ele['name']
		end
	end
	if doc['doc']['comments']['summary']['total_count'] > 0
		doc['doc']['comments']['data'].each do |ele|
			user[ele['id']] << ele['name']
		end

	end
end
############check group############
client = mongo_client([ '192.168.26.180:27017' ],'fb_group','admin','12345')
client[:feeds].find().each do |doc|
	user[doc['doc']['from']['id']] << doc['doc']['from']['name']
	if doc['doc']['likes']['summary']['total_count'] > 0
		doc['doc']['likes']['data'].each do |ele|
			user[ele['id']] << ele['name']
		end
	end
	if doc['doc']['comments']['summary']['total_count'] > 0
		doc['doc']['comments']['data'].each do |ele|
			user[ele['id']] << ele['name']
		end

	end
end


user.each do |k,v|
	v = v.uniq
	puts "#{k}\t#{v}" if v.size > 1
end