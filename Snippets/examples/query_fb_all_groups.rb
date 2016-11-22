require './mongo_client'
require 'time'
Mongo::Logger.logger.level = ::Logger::FATAL
now = Time.now.to_s
client = mongo_client([ '192.168.26.180:27017' ],'fb_group','admin','12345')
groups = Hash.new(0)
client[:groups].find().each do|doc|
	groups[doc['doc']['id']] = doc['doc']['name']
end
File.open("./log/fb_all_group#{now}.txt",'w+') do |output|
	total_count = 0
	early_day = Array.new(0)
	latest_day = Array.new(0)
	#error = Array.new(0)
	groups.each do |k,v|
		feeds = Array.new(0)
		client[:feeds].find("group_id"=>k).each do |doc|
				feeds << doc['feed_time']
		end
		#if feeds.size > 0
		feeds = feeds.sort
		output.puts "#{v}\t#{feeds[0]}\t#{feeds[-1]}\t#{feeds.size}"
		#if  posts[0] ==nil
		#	error << "#{k}"
		#else
		#	early_day << posts[0]	
		#end
		early_day << feeds[0]
		latest_day << feeds[-1]
		total_count += feeds.size
		#end
	end
	early_day = early_day.sort
	latest_day = latest_day.sort
	output.puts "共<#{groups.size} 個社團><#{total_count} 篇文章>"
	output.puts "文章時間從 #{early_day[0]} 到 #{latest_day[-1]}"
	#p error
end
puts "complicate"
