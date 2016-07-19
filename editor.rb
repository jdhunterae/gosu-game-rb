#!/usr/bin/env ruby
# Project: Gosu/Ruby Platforming Game 'FuZeD'
# Date: Jul 18, 2016
# Author: Andrew Pomerleau

$LOAD_PATH << File.dirname(__FILE__)

# Gem requires

# Editor Class requires
require 'edr/editor_window'

def main
    window = EditorWindow.new
    window.show
end

main
