domain_keys = ['寶寶']#','孕婦','媽媽','包屁衣']
name = 'wefwfwef寶寶1dwqf'
domain_keys.each do |ele|
	regular_result = /#{Regexp.escape(ele)}/.match(name).to_s
	puts regular_result.class
end