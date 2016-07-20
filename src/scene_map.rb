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
        @tile_data = []
        data_raw = File.read("res/tls/#{@tileset_used.delete('.png')}.pass")
        pass = data_raw.scan(/\d+/)
        @tile_data = pass.collect!(&:to_i)
        @hidden_tiles = []

        @player = nil
        @entities = []
        load_entities

        @cam_x = 0
        @cam_y = 0
    end

    def update
        if @window.button_down?(Gosu::KbLeft) && !is_a_wall?(:left)
            @player.move_left
        end
        if @window.button_down?(Gosu::KbRight) && !is_a_wall?(:right)
            @player.move_right
        end

        @player.update

        if [0, 2, 4].include?(tile_info(@player.x, @player.y, :down))
            @player.fall
            @player.respawn if tile_info(@player.x, @player.y, :down) == 4
        else
            @player.reset_acceleration
        end
        loop do
            break if [0, 2].include?(tile_info(@player.x, @player.y - 1, :down))
            @player.move_up
        end
        @player.reset_jump if @player.is_jumping? && tile_info(@player.x, @player.y, :up) != 0

        @player.slide_left if tile_info(@player.x, @player.y, :down) == 5
        @player.slide_right if tile_info(@player.x, @player.y, :down) == 6

        if in_hidden_entrance?
            @hidden_tiles = []
            (0...@level[1].size).each do |y|
                (0...@level[1][y].size).each do |x|
                    cur_x = (x * 16) + 8
                    cur_y = (y * 16) + 8
                    dist = Gosu.distance(@player.x, @player.y(:center), cur_x, cur_y)
                    @hidden_tiles << [x, y] if dist < 32
                end
            end
        else
            @hidden_tiles = []
        end

        @cam_x = [[@player.x - 320, 0].max, @level[0][0].size * 16 - 640].min
        @cam_y = [[@player.y - 240, 0].max, @level[0].size * 16 - 480].min
    end

    def draw
        (0...@level.size).each do |l|
            (0...@level[l].size).each do |y|
                (0...@level[l][y].size).each do |x|
                    if l == 1 && @hidden_tiles.include?([x, y])
                        @tileset[@level[l][y][x]].draw((x * 16) - @cam_x, (y * 16) - @cam_y, l + 1, 1, 1, Gosu::Color.new(160, 255, 255, 255))
                    else
                        @tileset[@level[l][y][x]].draw((x * 16) - @cam_x, (y * 16) - @cam_y, l + 1)
                    end
                end
            end
        end

        @player.draw(@cam_x, @cam_y, 1)
    end

    def button_down(id)
        @player.jump if id == Gosu::KbUp && is_on_solid_ground?
    end

    def is_on_solid_ground?
        [1, 3, 5, 6].include?(tile_info(@player.x, @player.y, :down))
    end

    def is_a_wall?(direction)
        [1, 2].include?(tile_info(@player.x, @player.y, direction))
    end

    def button_up(id)
        @player.reset_jump if id == Gosu::KbUp && @player.is_jumping?
    end

    def tile_info(x, y, pos = :down)
        tile_x = (x / 16).to_i
        tile_y = (y / 16).to_i
        case pos
        when :up
            tile_y -= 2
        when :right
            tile_x += 1
            tile_y -= 1
        when :left
            tile_x -= 1
            tile_y -= 1
        end

        @tile_data[@level[0][tile_y][tile_x]]
    end

    def in_hidden_entrance?
        tile_x = (@player.x / 16).to_i
        tile_y = (@player.y / 16).to_i

        @level[1][tile_y - 1][tile_x] > 0
    end

    def load_entities
        (0...@objects.size).each do |i|
            next if @objects[i].nil? || @objects[i][0] != :player

            @player = Player.new(@window, @objects[i][1], @objects[i][2])
        end
    end
end
