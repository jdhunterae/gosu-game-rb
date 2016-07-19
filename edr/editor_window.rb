require 'gosu'

require 'edr/scene_editor'

# Main game window
class EditorWindow < Gosu::Window
    DEFAULT_WIDTH = 1024
    DEFAULT_HEIGHT = 768
    DEFAULT_RESIZABLE = false
    DEFAULT_TITLE = 'FuZeD: Map Editor'.freeze

    def initialize
        super(DEFAULT_WIDTH, DEFAULT_HEIGHT, DEFAULT_RESIZABLE)
        self.caption = DEFAULT_TITLE

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
