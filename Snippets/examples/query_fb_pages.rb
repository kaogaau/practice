require './mongo_client'
client = mongo_client([ '192.168.26.180:27017' ],'test_kaogaau','admin','12345')
hash = Hash.new(0)
client[:pages].find.each do|doc|
	hash[doc['doc']['id']] = doc['doc']['name']
end
File.open('./log/fb_pages.txt','w+') do |output|
	hash.each do |k,v|
		output.puts "\"#{k}\":\"#{v}\","
	end
end
puts "=====total_pages:#{client[:pages].find.count}====="
