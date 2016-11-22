require 'mongoid'
Mongoid.load!("./mongoid.yml", :production)
#Mongoid.logger.level = Logger::DEBUG
class Pages
  include Mongoid::Document
  #field :latest_post_time
end
pages = Pages.where(:_id => "217633471595956")
#pages = Pages.find('217633471595956')
puts pages.all
#puts pages.doc.name