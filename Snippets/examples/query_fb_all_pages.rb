require './mongo_client'
require 'time'
Mongo::Logger.logger.level = ::Logger::FATAL
now = Time.now.to_s
client = mongo_client([ '192.168.26.180:27017' ],'fb_rawdata','admin','12345')
pages = Hash.new(0)
client[:pages].find().each do|doc|
	pages[doc['doc']['name']] += 1
end
File.open("./log/fb_all_#{now}.txt",'w+') do |output|
	total_count = 0
	early_day = Array.new(0)
	latest_day = Array.new(0)
	#error = Array.new(0)
	pages.each do |k,v|
		posts = Array.new(0)
		client[:posts].find("doc.from.name"=>k).each do |doc|
				posts << doc['post_time']
		end
		posts = posts.sort
		output.puts "#{k}\t#{posts[0]}\t#{posts[-1]}\t#{posts.size}"
		#if  posts[0] ==nil
		#	error << "#{k}"
		#else
		#	early_day << posts[0]	
		#end
		early_day << posts[0]
		latest_day << posts[-1]
		total_count += posts.size
	end
	early_day = early_day.sort
	latest_day = latest_day.sort
	output.puts "共<#{pages.size} 個粉絲團><#{total_count} 篇文章>"
	output.puts "文章時間從 #{early_day[0]} 到 #{latest_day[-1]}"
	#p error
end
puts "complicate"
