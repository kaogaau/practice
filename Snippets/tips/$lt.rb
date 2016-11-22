require './mongo_client'
#require 'bson'
Mongo::Logger.logger.level = ::Logger::FATAL
client = mongo_client([ '192.168.26.180:27017' ],'fb_group','admin','12345')
doc_set = client[:user_group].find({:user_group_status => "has group",:latest_update_time => { "$lt" => Time.now - 360000000 }})
#doc_set = client[:user_group].find
puts doc_set.class
doc_set.each do |ele|
	puts ele.class
end