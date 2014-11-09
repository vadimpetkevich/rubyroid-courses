class Time
	def ymd
		strftime '%y %m %d'  
	end
	def yBd
		strftime '%y %B %d'
	end
	def HMS
		strftime '%H %M %S'
	end
end