require 'mysql2'
client = Mysql2::Client.new(:username => "kaogaau",:password=>'12345',:host => "localhost",:port => 3306,:database=>'fb_page_test')#用mysql2
client.query("INSERT INTO test (test) VALUES (5)")
result = Mysql2::Result.new
puts result.count