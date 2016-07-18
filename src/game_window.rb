require 'gosu'

# Main game window
class GameWindow < Gosu::Window
    DEFAULT_WIDTH = 640
    DEFAULT_HEIGHT = 480
    DEFAULT_RESIZABLE = false
    DEFAULT_TITLE = 'FuZeD'.freeze

    def initialize
        super(DEFAULT_WIDTH, DEFAULT_HEIGHT, DEFAULT_RESIZABLE)
        self.caption = DEFAULT_TITLE
    end

    def update; end

    def draw; end

    def button_down(id); end

    def button_up(id); end
end
