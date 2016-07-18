require 'gosu'

class Player
    attr_reader :x, :y

    def initialize(window, x, y)
        @window = window
        @real_x = x
        @real_y = y
        @move_x = 0
        @moving = false
        @jump = 0
        @dir = :right

        @stand_right = Gosu::Image.load_tiles(@window, 'res/spr/player_standby_right.png', 32, 32, false)
        @stand_left = Gosu::Image.load_tiles(@window, 'res/spr/player_standby_left.png', 32, 32, false)
        @walk_right = Gosu::Image.load_tiles(@window, 'res/spr/player_run_right.png', 32, 32, false)
        @walk_left = Gosu::Image.load_tiles(@window, 'res/spr/player_run_left.png', 32, 32, false)
        @jump_right = Gosu::Image.load_tiles(@window, 'res/spr/player_jump_right.png', 32, 32, false)
        @jump_left = Gosu::Image.load_tiles(@window, 'res/spr/player_jump_left.png', 32, 32, false)
        @sprite = @stand_right

        @x = @real_x + (@sprite[0].width / 2)
        @y = @real_y + @sprite[0].height
    end

    def update
        @real_x = @x - (@sprite[0].width / 2)
        @real_y = @y - @sprite[0].height

        if @moving
            if @move_x > 0
                @move_x -= 1
                @x += 1
            elsif @move_x < 0
                @move_x += 1
                @x -= 1
            else
                @moving = false
            end
        else
            @sprite = if @dir == :left
                          @stand_left
                      else
                          @stand_right
                      end
        end

        if is_jumping?
            @y -= 5

            @sprite = if @dir == :left
                          @jump_left
                      else
                          @jump_right
                      end
            @jump -= 1
        end
    end

    def draw(z = 5)
        frame = Gosu.milliseconds / 150 % @sprite.size
        @sprite[frame].draw(@real_x, @real_y, z)
    end

    def move_left
        @dir = :left
        @move_x = -3
        @sprite = @walk_left if @jump == 0
        @moving = true
    end

    def move_right
        @dir = :right
        @move_x = 3
        @sprite = @walk_right if @jump == 0
        @moving = true
    end

    def fall
        if @jump == 0
            @y += 2

            @sprite = if @dir == :left
                          @jump_left
                      else
                          @jump_right
                      end
        end
    end

    def jump
        @jump = 15 if @jump == 0
    end

    def reset_jump
        @jump = 0
    end

    def is_jumping?
        @jump > 0
    end
end
