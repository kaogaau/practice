error_hash = Hash.new(0) 
File.open('./group_logger/group1.log','r+') do |file|
	file.readlines.each do |ele|
		key = ele.split('--')[1].to_s
		key = "FbPageCrawler: Database command 'insert' failed:" if key[0..48] == " FbPageCrawler: Database command 'insert' failed:"
		key = 'FbPageCrawler: Retrieve a error message: {"error"=>{"message"=>"Error validating access token: Session is invalid. This could be because the application was uninstalled after the session was created.", "type"=>"OAuthException", "code"=>190, "error_subcode"=>461}} on querying ' if key[0..276] == ' FbPageCrawler: Retrieve a error message: {"error"=>{"message"=>"Error validating access token: Session is invalid. This could be because the application was uninstalled after the session was created.", "type"=>"OAuthException", "code"=>190, "error_subcode"=>461}} on querying '
		key = 'FbPageCrawler: Retrieve a error message: {"error"=>{"code"=>1, "message"=>"An unknown error occurred"}} on querying'  if key[0..115] == ' FbPageCrawler: Retrieve a error message: {"error"=>{"code"=>1, "message"=>"An unknown error occurred"}} on querying'
		key = 'FbPageCrawler: Runner error: Overflow sort stage buffered data usage of' if key[0..71] == ' FbPageCrawler: Runner error: Overflow sort stage buffered data usage of'
		key = 'FbPageCrawler: Retrieve a error message: {"error"=>{"message"=>"An unexpected error has occurred. Please retry your request later.", "type"=>"OAuthException", "is_transient"=>true, "code"=>2}} on querying' if key[0..204] == ' FbPageCrawler: Retrieve a error message: {"error"=>{"message"=>"An unexpected error has occurred. Please retry your request later.", "type"=>"OAuthException", "is_transient"=>true, "code"=>2}} on querying' 
		key = ' FbPageCrawler: Retrieve a error message: {"error"=>{"code"=>-3, "message"=>"Please reduce the amount of data you\'re asking for, then retry your request"}} on querying' if key[0..166] == ' FbPageCrawler: Retrieve a error message: {"error"=>{"code"=>-3, "message"=>"Please reduce the amount of data you\'re asking for, then retry your request"}} on querying' 
		error_hash[key] += 1
	end
end
File.open('./group_logger/group2.log','r+') do |file|
	file.readlines.each do |ele|
		key = ele.split('--')[1].to_s
		key = "FbPageCrawler: Database command 'insert' failed:" if key[0..48] == " FbPageCrawler: Database command 'insert' failed:"
		key = 'FbPageCrawler: Retrieve a error message: {"error"=>{"message"=>"Error validating access token: Session is invalid. This could be because the application was uninstalled after the session was created.", "type"=>"OAuthException", "code"=>190, "error_subcode"=>461}} on querying ' if key[0..276] == ' FbPageCrawler: Retrieve a error message: {"error"=>{"message"=>"Error validating access token: Session is invalid. This could be because the application was uninstalled after the session was created.", "type"=>"OAuthException", "code"=>190, "error_subcode"=>461}} on querying '
		key = 'FbPageCrawler: Retrieve a error message: {"error"=>{"code"=>1, "message"=>"An unknown error occurred"}} on querying'  if key[0..115] == ' FbPageCrawler: Retrieve a error message: {"error"=>{"code"=>1, "message"=>"An unknown error occurred"}} on querying'
		key = 'FbPageCrawler: Runner error: Overflow sort stage buffered data usage of' if key[0..71] == ' FbPageCrawler: Runner error: Overflow sort stage buffered data usage of'
		key = 'FbPageCrawler: Retrieve a error message: {"error"=>{"message"=>"An unexpected error has occurred. Please retry your request later.", "type"=>"OAuthException", "is_transient"=>true, "code"=>2}} on querying' if key[0..204] == ' FbPageCrawler: Retrieve a error message: {"error"=>{"message"=>"An unexpected error has occurred. Please retry your request later.", "type"=>"OAuthException", "is_transient"=>true, "code"=>2}} on querying' 
		key = ' FbPageCrawler: Retrieve a error message: {"error"=>{"code"=>-3, "message"=>"Please reduce the amount of data you\'re asking for, then retry your request"}} on querying' if key[0..166] == ' FbPageCrawler: Retrieve a error message: {"error"=>{"code"=>-3, "message"=>"Please reduce the amount of data you\'re asking for, then retry your request"}} on querying'
		error_hash[key] += 1
	end
end
File.open('./group_logger/group3.log','r+') do |file|
	file.readlines.each do |ele|
		key = ele.split('--')[1].to_s
		key = "FbPageCrawler: Database command 'insert' failed:" if key[0..48] == " FbPageCrawler: Database command 'insert' failed:"
		key = 'FbPageCrawler: Retrieve a error message: {"error"=>{"message"=>"Error validating access token: Session is invalid. This could be because the application was uninstalled after the session was created.", "type"=>"OAuthException", "code"=>190, "error_subcode"=>461}} on querying ' if key[0..276] == ' FbPageCrawler: Retrieve a error message: {"error"=>{"message"=>"Error validating access token: Session is invalid. This could be because the application was uninstalled after the session was created.", "type"=>"OAuthException", "code"=>190, "error_subcode"=>461}} on querying '
		key = 'FbPageCrawler: Retrieve a error message: {"error"=>{"code"=>1, "message"=>"An unknown error occurred"}} on querying'  if key[0..115] == ' FbPageCrawler: Retrieve a error message: {"error"=>{"code"=>1, "message"=>"An unknown error occurred"}} on querying'
		key = 'FbPageCrawler: Runner error: Overflow sort stage buffered data usage of' if key[0..71] == ' FbPageCrawler: Runner error: Overflow sort stage buffered data usage of'
		key = 'FbPageCrawler: Retrieve a error message: {"error"=>{"message"=>"An unexpected error has occurred. Please retry your request later.", "type"=>"OAuthException", "is_transient"=>true, "code"=>2}} on querying' if key[0..204] == ' FbPageCrawler: Retrieve a error message: {"error"=>{"message"=>"An unexpected error has occurred. Please retry your request later.", "type"=>"OAuthException", "is_transient"=>true, "code"=>2}} on querying' 
		key = ' FbPageCrawler: Retrieve a error message: {"error"=>{"code"=>-3, "message"=>"Please reduce the amount of data you\'re asking for, then retry your request"}} on querying' if key[0..166] == ' FbPageCrawler: Retrieve a error message: {"error"=>{"code"=>-3, "message"=>"Please reduce the amount of data you\'re asking for, then retry your request"}} on querying'
		error_hash[key] += 1
	end
end
File.open('./group_logger/group_total_logger.txt','w+') do |output|
	error_hash.each do |k,v|
		output.puts "#{k}"
	end
end
puts "complicate"