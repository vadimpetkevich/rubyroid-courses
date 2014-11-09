require 'test/unit'
require 'extime'
class ExtimeTest < Test::Unit::TestCase
	def test_ymd
		assert_equal Time.now.strftime('%y %m %d'), Time.now.ymd
	end
	def test_yBd
		assert_equal Time.now.strftime('%y %B %d'), Time.now.yBd
	end
	def test_HMS
		assert_equal Time.now.strftime('%H %M %S'), Time.now.HMS
	end
end