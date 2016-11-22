require './mongo_client'
client = mongo_client([ '192.168.26.180:27017' ],'fb_tachen','tachen','iscae100')
hash = Hash.new(0)
client[:userlikes].find.each do|doc|
	hash[doc['pagename']] += 1
end
File.open('./log/fb_userlikes.txt','w+') do |output|
	hash.each do |k,v|
		output.puts "#{k}\t#{v}"
	end
end
puts "=====total_pages:#{client[:userlikes].find.count}====="
