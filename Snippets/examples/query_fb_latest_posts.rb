require './mongo_client'
require 'time'
now = Time.now.to_s
client = mongo_client([ '192.168.26.180:27017' ],'test_kaogaau','admin','12345')
pages = Hash.new(0)
client[:pages].find().each do|doc|
	pages[doc['doc']['name']] += 1
end
File.open('./log/fb_latest_posts.txt','w+') do |output|
	pages.each do |k,v|
		output.write "#{k}\t"
		posts = Hash.new(0)
		client[:posts].find("doc.from.name"=>k).each do |doc|
				posts[doc['doc']['link']] = doc['post_time']
		end
		posts = posts.sort_by{|m,n| n}.reverse
		index = 0
		posts.each do |m,n|
			output.write "#{posts.size}\t#{n}"
			index += 1
			if index == 1
				break
			end
		end
		output.write "\n"
	end
end
puts "complicate"
