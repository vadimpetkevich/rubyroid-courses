#!/usr/bin/env ruby

require_relative 'request.rb'
require 'colorize'
require 'zlib'

request = Request.new ARGV
ARGV.clear

puts request.result if request.result