require 'gosu'

require 'src/player'

class SceneMap
    def initialize(window)
        @window = window
        @player = Player.new(@window, 196, 16)

        @tileset = Gosu::Image.load_tiles(@window, 'res/tls/area02.png', 16, 16, true)
        @level = demo_map
    end

    def update
        @player.update
        @player.move_right if @window.button_down?(Gosu::KbRight) && !wall?(@player.x, @player.y, :right)
        @player.move_left if @window.button_down?(Gosu::KbLeft) && !wall?(@player.x, @player.y, :left)
        @player.fall if no_ground?(@player.x, @player.y)
        @player.reset_jump if @player.is_jumping? && solid_overhead?(@player.x, @player.y)
    end

    def draw
        (0...@level.size).each do |y|
            (0...@level[y].size).each do |x|
                @tileset[@level[y][x]].draw(x * 16, y * 16, 1)
            end
        end

        @player.draw
    end

    def button_down(id)
        if id == Gosu::KbUp
            @player.jump unless no_ground?(@player.x, @player.y)
        end
    end

    def button_up(id)
        @player.reset_jump if id == Gosu::KbUp
    end

    def no_ground?(x, y)
        tile_x = (x / 16).to_i
        tile_y = (y / 16).to_i
        @level[tile_y][tile_x] == 0
    end

    def solid_overhead?(x, y)
        tile_x = (x / 16).to_i
        tile_y = (y / 16).to_i
        @level[tile_y - 2][tile_x] != 0
    end

    def wall?(x, y, direction)
        tile_x = (x / 16).to_i
        tile_y = (y / 16).to_i
        return @level[tile_y - 1][tile_x - 1] != 0 if direction == :left
        @level[tile_y - 1][tile_x + 1] != 0
    end

    def demo_map
        level = [
            [14, 14, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 23, 0, 0, 0, 0, 0, 0, 0, 0],
            [14, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [14, 2, 2, 2, 2, 2, 2, 5, 0, 0, 0, 0, 0, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
            [14, 14, 14, 14, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 21, 22, 22, 22, 22, 14, 14, 14, 14, 14, 14],
            [14, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 21, 14, 14],
            [14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 21, 14],
            [14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14],
            [14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14],
            [14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14],
            [14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14],
            [14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14],
            [14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14],
            [14, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 14]
        ]
        level
    end
end
