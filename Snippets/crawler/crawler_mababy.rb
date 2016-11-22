# encoding: UTF-8
require 'nokogiri'
require 'open-uri'
require 'faraday'
require 'rubygems'
require 'json'
require 'bson'
require 'mongo'
include Mongo
############link############
def link(url)
	response = Faraday.get(url)
	case response.status
		when 200
	  		@html = response.body
		when 301..302
	  		@html = Faraday.get(response[:Location])
	end
end
##########mongo##########
MONGODB_HOST = '192.168.26.180'
MONGODB_PORT = 27017
MONGODB_DBNAME = 'mababy'
MONGODB_USER_NAME = 'phadmin'
MONGODB_USER_PWD = 'pw1874'
client = MongoClient.new(MONGODB_HOST, MONGODB_PORT)
client.add_auth(MONGODB_DBNAME, MONGODB_USER_NAME, MONGODB_USER_PWD, MONGODB_DBNAME)
db = client[MONGODB_DBNAME]
coll = db['product_try']
doc_count = 1
#########################
for i in 1..176#176
	post_link = Array.new()
	post_title = Array.new()
	post_author = Array.new()
	post_time = Array.new()
	post_vist = Array.new()
	post_response = Array.new()
	post_content = Array.new()
	###################
	url = "http://www.mababy.com/forum/title.aspx?tid=695EC97F0020108C&page=#{i}"
	doc = Nokogiri::HTML(link(url))
	doc.xpath('//tr/td[@class="forum_list_t"]/a').each do |tag|
		post_link << 'http://www.mababy.com/forum/' + tag['href'] 
		post_title << tag.text
	end
	doc.xpath('//tr/td[@class="list_pink"]').each do |tag|
		tag.text.each_line do |line|
			str = line.chomp.strip
			if str  != "" && !str.match(/\//)
				post_author << str.to_s
			elsif str  != "" && str.match(/\//)
				post_time << str	.to_s
			end
		end
	end
	doc.xpath('//tr/td[@class="list_grey"][1]').each do |tag|
		post_response  << tag.text.match(/\d+/).to_s
	end
	doc.xpath('//tr/td[@class="list_grey"][2]').each do |tag|
		post_vist << tag.text.match(/\d+/).to_s
	end
	###################
	post_link.each_with_index do |url,index|
		begin
			mababy = {"doc"=>{"post_link"=>"","post_title"=>"","post_author"=>"","post_time"=>"","post_vist"=>"","post_response"=>"","post_content"=>"","response"=>{}}}
			response_author = Array.new()
			response_time = Array.new()
			response_content = Array.new()
			next_page_link = Array.new()
			###################
			doc = Nokogiri::HTML(link(url))
			post_content << doc.xpath('//div[@id="TitleContent"]').text.strip.delete("\r\n")
			next_page_link << url
			doc.xpath('//tr/td[@class="yema_num"]/a').each do |tag|
				next_page_link << tag['href']
			end
			next_page_link.each do |next_page|
				doc = Nokogiri::HTML(link(next_page))
				doc.xpath('//tr/td[@class="frame_text" and @width="257"]').each do |tag|
					response_author << tag.text.match(/[a-zA-z\d]+/).to_s
				end
				doc.xpath('//tr/td[@class="frame_text"  and @width="188"]').each do |tag|
					response_time << tag.text.match(/\d{4}\/\d{2}\/\d{2} \d{2}:\d{2}/).to_s
				end
				doc.xpath('//tr/td[@valign="top" and @colspan="4"]').each do |tag|
					response_content << tag.text.strip.delete("\r\n")
				end
			end
			mababy['doc']['post_link'] = url
			mababy['doc']['post_title'] = post_title[index]
			mababy['doc']['post_author'] = post_author[index]
			mababy['doc']['post_time'] = post_time[index]
			mababy['doc']['post_vist'] = post_vist[index]
			mababy['doc']['post_response'] = post_response[index]
			mababy['doc']['post_content'] = post_content[index]
			response_author.each_with_index do |ele,count|
				mababy['doc']['response']["#{count+1} F"] = {"response_author"=>response_author[count],"response_time"=>response_time[count],"response_content"=>response_content[count]}
			end
			coll.insert(mababy)
			puts "update #{doc_count} document"
			doc_count += 1
		rescue Exception => e
			next
			puts e
		end
	end
end
puts "全部完成"