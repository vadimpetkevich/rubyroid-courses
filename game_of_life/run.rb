#!/usr/bin/env ruby
require_relative 'life.rb'
require 'curses'
require 'colored'

level_colors = { 0 => :black, 1 => :cyan, 2 => :blue, 3 => :yellow, 4 => :green, 5 => :magenta, 6 => :red }

Curses.init_screen
Curses.curs_set 0

screen_width = Curses.lines
screen_height = Curses.cols

life = Life.new [screen_width, screen_height].min / 2, level_colors.size - 1

begin
  life.generation.to_a.each do |line|
  	line.each { |cell| print '@'.send(level_colors[cell]) + ' ' }
    print "\n\r"
  end
  
  sleep 0.1
  Curses.clear
  Curses.refresh
end until life.to_next_generation.nil?

Curses.close_screen