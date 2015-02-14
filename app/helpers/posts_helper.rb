module PostsHelper
	def httpize(string)
		if string[0..3] == 'http'
			return string
		else
			return "http://" + string
		end
	end
end
