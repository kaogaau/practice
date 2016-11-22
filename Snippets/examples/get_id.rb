require 'json'
require 'net/http'
link = ARGV[0]
token = 'CAAH9Ulnk1cQBAGZBpJtYasnTOBbnM9KPL1QZBeMXJ2ZBXDCb0bXaBhn80pWJodrpj2GN5EybHng3hW9ccIt2QFamoiNQxksCDIpfOa2hZA1YxmZA6gZAM2UdNzIHXrn64sOoxmo5lVHZCajLtuWKZAi5Dy9rZCXQP3ZAOqxUEj6g33HaOZAhG8ZAeNhw4JazXvRZCgZCtnhGqLCe9rfHCWx3mszBx1gBbdq4o9lTwZD'
if link.size > 32 and link[0..31] == 'https://www.facebook.com/groups/'
	#puts "link is fb group"
	iden = link[32..-2]
	#puts iden
	uri = URI("https://graph.facebook.com/#{iden}?access_token=#{token}")
	result = JSON.parse(Net::HTTP.get(uri))
	if !result.has_key?('error')
			puts "輸入連結為 : #{link}"
			puts "成功擷取ID!如果您查詢的社團名稱為<#{result['name']}>無誤,則此社團ID為<#{result['id']}>"
	else
		uri = URI("https://graph.facebook.com/search?q=#{iden}&type=group&access_token=#{token}")
		result = JSON.parse(Net::HTTP.get(uri))
		if !result.has_key?('error') && result.has_key?('data')
			if result['data'].size == 1
					puts "輸入連結為 : #{link}"
					puts "成功擷取ID!如果您查詢的社團名稱為<#{result['data'][0]['name']}>無誤,則此社團ID為<#{result['data'][0]['id']}>"
			else
				puts "輸入連結為 : #{link}"
				puts "連結無效!請輸入有效連結"
			end
		else
			puts "輸入連結為 : #{link}"
			puts "連結無效!請輸入有效連結"
		end
	end
else
	puts "輸入連結為 : #{link}"
	puts "連結無效!請輸入有效連結"
end