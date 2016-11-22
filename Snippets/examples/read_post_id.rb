require './mongo_client'
Mongo::Logger.logger.level = ::Logger::FATAL
client = mongo_client([ '192.168.26.180:27017' ],'fb_rawdata','admin','12345')
doc_set = client[:posts].find()
hash = Hash.new(0)
doc_set.each do |doc|
	hash[doc['_id'].split('_')[1]] += 1
end
puts hash.keys.size