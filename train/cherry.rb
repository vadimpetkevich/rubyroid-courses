#!/usr/bin/env ruby

require_relative 'image.rb'
require 'curses'

Curses.init_screen
Curses.curs_set 0

cherry_entity = [
                  '   #####     ',
                  '   ########   ',
                  '    ###   ######',
                  '     ###     ####',
                  '       ####      #',
                  '         #########',
                  '          ########',
                  '               ####',
                  '              #  #',
                  '             ##   ##',
                  '            #       #',
                  '            #         ##',
                  '           ##           #',
                  '          ##             ##',
                  '        ###          ##########',
                  '  ###########    ##   #### ###',
                  ' ##    #######   #  #####  ####',
                  '##    ##### ###  ### ## ## ####',
                  '#     #########  #############',
                  '###############  ##########',
                  '  #############   #########',
                  '   ##########    '
                 ]

cherry = Image.new cherry_entity
class << cherry
  def edit_entity
    @entity.each do |str|
      if str['#']
        str.gsub! '#', '_'
      else
        str.gsub! '_', '#'
      end
    end
  end
end
cherry.move
Curses.close_screen