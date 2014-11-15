require_relative 'lib/cowsay'
require_relative 'lib/happy_new_year.rb'

use Rack::Reloader
use HappyNewYear
run Cowsay.new

