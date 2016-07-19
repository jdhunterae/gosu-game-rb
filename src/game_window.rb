# Gem requires
require 'gosu'

# Game Class requires
require 'src/scene_map'

# Main game window
class GameWindow < Gosu::Window
    WINDOW_WIDTH = 640
    WINDOW_HEIGHT = 480
    WINDOW_RESIZABLE = false
    WINDOW_TITLE = 'FuZeD'.freeze

    def initialize
        super(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_RESIZABLE)
        self.caption = WINDOW_TITLE
        @scene = SceneMap.new(self)
    end

    def update
        @scene.update
    end

    def draw
        @scene.draw
    end

    def button_down(id)
        close if id == Gosu::KbEscape
        @scene.button_down(id)
    end

    def button_up(id)
        @scene.button_up(id)
    end
end
