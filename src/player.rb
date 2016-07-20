# Gem requires
require 'gosu'

class Player
    attr_reader :x

    def initialize(window, x, y)
        @window = window
        @real_x = x
        @real_y = y
        @spawn_x = x
        @spawn_y = y
        @dir = :right
        @move_x = 0
        @moving = false
        @jump = 0
        @v_acc = 1
        @max_v_acc = 15

        @stand_right = Gosu::Image.load_tiles(@window, 'res/spr/player_standby_right.png', 32, 32, false)
        @stand_left = Gosu::Image.load_tiles(@window, 'res/spr/player_standby_left.png', 32, 32, false)
        @walk_left = Gosu::Image.load_tiles(@window, 'res/spr/player_run_left.png', 32, 32, false)
        @walk_right = Gosu::Image.load_tiles(@window, 'res/spr/player_run_right.png', 32, 32, false)
        @jump_left = Gosu::Image.load_tiles(@window, 'res/spr/player_jump_left.png', 32, 32, false)
        @jump_right = Gosu::Image.load_tiles(@window, 'res/spr/player_jump_right.png', 32, 32, false)
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
                @x += 3
            elsif @move_x < 0
                @move_x += 1
                @x -= 3
            elsif @move_x == 0
                @moving = false
            end
        else
            if @dir == :left
                @sprite = @stand_left
            elsif @dir == :right
                @sprite = @stand_right
            end
        end

        if is_jumping?
            @y -= @v_acc
            @v_acc *= 0.75
            if @dir == :left
                @sprite = @jump_left
            elsif @dir == :right
                @sprite = @jump_right
            end
            @jump -= 1
        end
    end

    def draw(cam_x, cam_y, z = 5)
        frame = Gosu.milliseconds / 90 % @sprite.size
        @sprite[frame].draw(@real_x - cam_x, @real_y - cam_y, z)
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

    def move_up
        @y -= 1
    end

    def fall
        if @jump == 0
            @y += @v_acc
            @v_acc = [@v_acc * 1.25, @max_v_acc].min
            if @dir == :left
                @sprite = @jump_left
            elsif @dir == :right
                @sprite = @jump_right
            end
        end
    end

    def jump
        @jump = 12 if @jump == 0
        @v_acc = 20
    end

    def reset_jump
        @jump = 0
        @v_acc = 1
    end

    def slide_left
        @x -= random(3, 5)
        @y -= random(1, 4)
        @dir = :left
        @sprite = @jump_left
    end

    def slide_right
        @x += random(3, 5)
        @y -= random(1, 4)
        @dir = :right
        @sprite = @jump_right
    end

    def respawn
        @real_x = @spawn_x
        @real_y = @spawn_y
        @x = @real_x + (@sprite[0].width / 2)
        @y = @real_y + @sprite[0].height
    end

    def reset_acceleration
        @v_acc = 1
    end

    def y(arg = nil)
        return @real_y + @sprite[0].height / 2 if arg == :center
        @y
    end

    def is_jumping?
        @jump > 0
    end
end
