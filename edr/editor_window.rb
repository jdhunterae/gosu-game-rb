# Gem requires
require 'gosu'

# Editor class requires
require 'edr/scene_editor'

# Main editor window
class EditorWindow < Gosu::Window
    WINDOW_WIDTH = 1024
    WINDOW_HEIGHT = 768
    WINDOW_RESIZABLE = false
    WINDOW_TITLE = 'FuZeD: Map Editor'.freeze

    def initialize
        super(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_RESIZABLE)
        self.caption = WINDOW_TITLE

        @scene = SceneEditor.new(self)
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

    def needs_cursor?
        true
    end
end
