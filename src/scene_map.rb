# Gem requires
require 'gosu'

# Game Class requires
require 'src/player'

class SceneMap
    def initialize(window)
        @window = window
        file = File.open('dat/001.map')
        @tileset_used = Marshal.load(file)
        @level = Marshal.load(file)
        @objects = Marshal.load(file)
        file.close

        @tileset = Gosu::Image.load_tiles(@window, "res/tls/#{@tileset_used}", 16, 16, true)
        @player = nil
        @entities = []
        load_entities

        @cam_x = 0
        @cam_y = 0
    end

    def update
        @player.move_left if @window.button_down?(Gosu::KbLeft) && !wall?(@player.x, @player.y, :left)
        @player.move_right if @window.button_down?(Gosu::KbRight) && !wall?(@player.x, @player.y, :right)

        @player.update

        @player.fall if no_ground?(@player.x, @player.y)
        @player.reset_jump if @player.is_jumping? && solid_overhead?(@player.x, @player.y)

        @cam_x = [[@player.x - 320, 0].max, @level[0][0].size * 16 - 640].min
        @cam_y = [[@player.y - 240, 0].max, @level[0].size * 16 - 480].min
    end

    def draw
        @player.draw(@cam_x, @cam_y)
        for l in 0...@level.size
            for y in 0...@level[l].size
                for x in 0...@level[l][y].size
                    @tileset[@level[l][y][x]].draw((x * 16) - @cam_x, (y * 16) - @cam_y, 1)
                end
            end
        end
    end

    def button_down(id)
        @player.jump if id == Gosu::KbUp && !no_ground?(@player.x, @player.y)
    end

    def button_up(id)
        @player.reset_jump if id == Gosu::KbUp && @player.is_jumping?
    end

    def no_ground?(x, y)
        tile_x = (x / 16).to_i
        tile_y = (y / 16).to_i
        @level[0][tile_y][tile_x] == 0
    end

    def wall?(x, y, direction)
        tile_x = (x / 16).to_i
        tile_y = (y / 16).to_i
        if direction == :left
            return @level[0][tile_y - 1][tile_x - 1] != 0
        elsif direction == :right
            return @level[0][tile_y - 1][tile_x + 1] != 0
        end
    end

    def solid_overhead?(x, y)
        tile_x = (x / 16).to_i
        tile_y = (y / 16).to_i
        @level[0][tile_y - 2][tile_x] != 0
    end

    def load_entities
        (0...@objects.size).each do |i|
            next if @objects[i].nil? || @objects[i][0] != :player

            @player = Player.new(@window, @objects[i][1], @objects[i][2])
        end
    end
end
