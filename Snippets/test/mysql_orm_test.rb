require 'rubygems' 
require 'active_record'  
#require './mongo_client'
ActiveRecord::Base.establish_connection(  
	:adapter  => "mysql",
	:host     => "220.132.97.119",
	#:host     => "192.168.26.180",
	:username => "root",
	:password => "iscae100",
	:database => "fb_page"
) 

#mongo_client = mongo_client( '192.168.26.180',27017,'fb_rawdata','admin','12345')


class Pages < ActiveRecord::Base  
end  

page = Pages.find(134469309158)
#puts page.methods
puts page.page_fans

