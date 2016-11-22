# encoding: UTF-8
require 'nokogiri'
require 'open-uri'
require 'Faraday'
require 'rubygems'
require 'json'
require 'bson'
require 'mongo'
include Mongo
MONGODB_HOST = '192.168.26.180'
MONGODB_PORT = 27017
MONGODB_DBNAME = 'les_enphants'
MONGODB_USER_NAME = 'phadmin'
MONGODB_USER_PWD = 'pw1874'
client = MongoClient.new(MONGODB_HOST, MONGODB_PORT)
client.add_auth(MONGODB_DBNAME, MONGODB_USER_NAME, MONGODB_USER_PWD, MONGODB_DBNAME)
mongo_db = client[MONGODB_DBNAME]
forums_list = Hash.new()
ec = Encoding::Converter.new("big5","utf-8",:invalid => :replace,:undef => :replace,:replace => 'A')
File.open('C:\Users\kaogaau\Desktop\babyhome.txt') do |doc|
	doc.each do |forums_url|
		forums_list[forums_url.force_encoding("UTF-8").chomp.split(/\t/)[1]] = forums_url.force_encoding("UTF-8").chomp.split(/\t/)[0]
	end
end
forums_list.each do |forums_url,forums_name|
	puts "進入 : #{forums_name}"
	coll = mongo_db["#{forums_name}"]
	response = Faraday.get(forums_url)
	case response.status
		when 200
  			@html = response.body
		when 301..302
  			@html = Faraday.get(response[:Location])
	end
	doc = Nokogiri::HTML(ec.convert(@html))
	if doc.css('div.pagination ul li:last-child')[0].text == doc.css('div.pagination ul li:last-child')[1].text && doc.css('div.pagination ul li:last-child')[1].text == "→"
		page = doc.css('div.pagination ul li:nth-last-child(2)')[1].text.delete('...').to_i
	elsif doc.css('div.pagination ul li:last-child')[0].text == doc.css('div.pagination ul li:last-child')[1].text && doc.css('div.pagination ul li:last-child')[1].text != "→"
		page = 	doc.css('div.pagination ul li:last-child')[1].text.to_i
	else
		puts "page error"
	end
	puts "總共#{page}頁"
	page_count = 0
	article_count = 0
	count = 0
	until page_count == page
		begin
		#############爬第N頁#############
		article = Hash.new {}
		article_count += count
		page_count += 1
		page_url = forums_url[0..forums_url.size-7]+"page=#{page_count}"
		response = Faraday.get(page_url)
		case response.status
			when 200
	  			@html = response.body
			when 301..302
	  			@html = Faraday.get(response[:Location])
		end
		doc = Nokogiri::HTML(ec.convert(@html))
		post_author = Array.new()
		doc.xpath('//tr/td[@class="span_author"]').each do |tag|
			post_author << tag.text
		end
		post_author.delete_at(0)
		doc.xpath('//tr/td[@class="span_title fonts_15"]/h3/a').each_with_index do |tag,index|
			article[(article_count+index+1).to_s] = {"link"=>'http://www.babyhome.com.tw/mboard/' + tag['href'],"title"=>tag.text,"post_author"=>post_author[index],"post_time"=>"","post_content"=>"","response"=>{}}
			count = index
		end
		#############爬第N頁文章內容##################
		post_time = Array.new()
		post_content = Array.new()
		article.each do |k,v|
			response = Faraday.get(v['link'])
			case response.status
				when 200
		  			@html = response.body
				when 301..302
		  			@html = Faraday.get(response[:Location])
			end
			doc = Nokogiri::HTML(ec.convert(@html))
			v['post_time'] = doc.xpath('//tr/td[@class="author_detail"]/span').text.delete('發表於')
			str = String.new
			doc.css('div.comment_content span p').each do |tag|
				str = str + tag.text
			end
			v['post_content'] = str
			li = Hash.new()
			doc.xpath('//div[@class="pagination fonts_13"]/ul/li/a').each do |tag|
				li[tag.text] = 'http://www.babyhome.com.tw/mboard/' + tag['href']
			end
			li['1'] = v['link']
			li.delete('返回列表')
			li.each do |m,n|
				response = Faraday.get(n)
				case response.status
					when 200
		  				@html = response.body
					when 301..302
		  				@html = Faraday.get(response[:Location])
				end
				doc = Nokogiri::HTML(ec.convert(@html))
				response_author = Array.new()
				response_time = Array.new()
				doc.xpath('//tr/td[@class="author_detail " and @height="42"]').each do |tag|
					response_time << tag.xpath('span').text.delete('發表於')
					tag.xpath('span').remove
					response_author << tag.text.delete(' ').delete("\n")
				end
				doc.xpath('//tr/td[@class="floor"]/span').each_with_index do |tag,index|
					str = String.new
					doc.xpath('//div[@id="floor_'+"#{tag.text}"+'"]/div[@class="comment_content"]/p').each do |tag|
						str = str + tag.text
					end
					v['response'][tag.text] = {"response_author"=>response_author[index],"response_time"=>response_time[index],"response_content"=>str}
				end
			end
		end
		article.each do |k,v|
			hash = Hash.new {}
			hash['doc'] = v
			coll.insert(hash)	
		end
		puts "第#{page_count}頁"
		###############第N頁完成################
		rescue Exception => e
			puts "第#{page_count}頁 錯誤"
			next
		end
	end
	######################輸出#########################
	puts "完成 : #{forums_name}"
	#########################下一頁##############################
end	
puts "全部完成"