require './mongo_client'
require 'time'
now = Time.now
Mongo::Logger.logger.level = ::Logger::FATAL
client = mongo_client([ '192.168.26.180:27017' ],'fb_rawdata','admin','12345')
hash = Hash.new(0)
client[:pages].find.each do|doc|
	hash[doc['doc']['id']] = doc['doc']['name']
end
hash2 = Hash.new(0)
hash3 = Hash.new(0)
puts "Check...Database"
hash.each do |id,name|
	client[:posts].find("page_id"=>id).each do |doc|
		if doc['doc'].has_key?("likes")
			if doc['doc']['likes'].has_key?("summary")
				hash2[name] += 1
			else
				hash3[name] += 1
			end
		else
			hash3[name] += 1
		end
	end
end
puts "Output...File"
File.open("./log/check_database_#{now}.txt",'w+') do |output|
	output.puts "fb_name\thas_likecount\thas_nolikecount"
	hash2.each do |name,count|
		output.puts "#{name}\t#{count}\t#{hash3[name]}"
	end
end
