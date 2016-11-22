require './mongo_client'
Mongo::Logger.logger.level = ::Logger::FATAL
client = mongo_client([ '192.168.26.180:27017' ],'fb_rawdata','admin','12345')
result = client[:pages].find(:check_old_posts => false).update_many('$set' => { :check_old_posts => true })
puts result