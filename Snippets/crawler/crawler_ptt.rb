# encoding: UTF-8
require 'nokogiri'
require 'open-uri'
require 'mongo'
#require 'json'
#require 'bson'

include Mongo
MONGODB_HOST = '192.168.26.180'
MONGODB_PORT = 27017
MONGODB_DBNAME = 'les_enphants'
MONGODB_USER_NAME = 'phadmin'
MONGODB_USER_PWD = 'pw1874'
client = MongoClient.new(MONGODB_HOST, MONGODB_PORT)
client.add_auth(MONGODB_DBNAME, MONGODB_USER_NAME, MONGODB_USER_PWD, MONGODB_DBNAME)
mongo_db = client[MONGODB_DBNAME]

for page in 1..1#2288
	url = "https://www.ptt.cc/bbs/BabyMother/index#{page}.html"
	page_doc = Nokogiri::HTML(open(url))
	page_doc.xpath('//div[@class="r-ent"]/div[@class="title"]/a').each do |tag|
		res = Hash.new{|k,v| res[v] = Hash.new}
		hash = {'post_link'=>'','post_title'=>'','post_author'=>'','post_time'=>'','post_content'=>'','response'=>res}
		hash['post_link'] = 'https://www.ptt.cc'+tag['href']
		hash['post_title'] = tag.text
		post_doc = Nokogiri::HTML(open(hash['post_link']))
		hash['post_author'] = post_doc.xpath('//span[@class="article-meta-value"]')[0].text
		hash['post_time'] = post_doc.xpath('//span[@class="article-meta-value"]')[3].text
		post_doc.xpath('//div[@class="push"]/span[@class="hl push-tag" or @class="f1 hl push-tag"]').each_with_index do |tag,index|
			hash['response']["#{index+1} F"]['response_tag']  = tag.text
		end
		post_doc.xpath('//div[@class="push"]/span[@class="f3 hl push-userid"]').each_with_index do |tag,index|
			hash['response']["#{index+1} F"]['response_id'] = tag.text
		end
		#post_doc.xpath('//div[@id="main-content"]/span[@class="push-content]').each do |tag|
		#	
		#end
		#post_doc.xpath('//div[@id="main-content"]/span[@class="push-ipdatetim]').each do |tag|
		#	
		#end
		#
		#post_doc.xpath('//div[@id="main-content"]/div').each do |tag|
		#	tag.remove
		#end
		#post_doc.xpath('//div[@id="main-content"]/span').each do |tag|
		#	tag.remove
		#end
		#hash['post_content'] = post_doc.xpath('//div[@id="main-content"]').text
		
		
		p hash
	end
end



puts "全部完成"