class Play
	def p1
		puts "p1"
	end
end
class Test < Play
	def t1
		puts "t1"
		t3
		p1
	end
	def t2
		puts "t2"
	end
	def t3
		puts "t3"
	end
end


test = Test.new
puts test.t1
#puts test.methods