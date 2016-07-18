#!/usr/bin/env ruby
# Project: Gosu/Ruby Platforming Game 'FuZeD'
# Date: Jul 18, 2016
# Author: Andrew Pomerleau

$LOAD_PATH << File.dirname(__FILE__)

require 'gosu'
require 'rubygems'

require 'src/game_window'

window = GameWindow.new
window.show
