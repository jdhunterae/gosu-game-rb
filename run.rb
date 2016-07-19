#!/usr/bin/env ruby
# Project: Gosu/Ruby Platforming Game 'FuZeD'
# Date: Jul 19, 2016
# Author: Andrew Pomerleau

$LOAD_PATH << File.dirname(__FILE__)

# Gem requires

# Game Class requires
require 'src/game_window'

def main
    window = GameWindow.new
    window.show
end

main
