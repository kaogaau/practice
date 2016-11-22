BEGIN{
	time_start = Time.now 
	puts "=================Start : #get_user_groups================="
}
END{
	puts "==================End : #get_user_groups=================="
	time_end = Time.now 
	puts "Time cost : #{Time.at(time_end-time_start).utc.strftime("%H:%M:%S")}"
}
sleep(10)