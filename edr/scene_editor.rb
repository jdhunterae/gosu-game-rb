# Gem requires
require 'gosu'

# Editor class requires
require 'edr/parser'

class SceneEditor
    GRID_HEIGHT = 45
    GRID_WIDTH = 60

    def initialize(window)
        @window = window

        if FileTest.exists?('res/cnf/layer0.csv') && FileTest.exists?('res/cnf/layer1.csv')
            parser = Parser.new
            @level = parser.parse_data(GRID_WIDTH, GRID_HEIGHT)
        else
            @level = []
            (0...2).each do |l|
                @level[l] = []
                (0...GRID_HEIGHT).each do |y|
                    @level[l][y] = []
                    (0...GRID_WIDTH).each do |x|
                        @level[l][y][x] = 0
                    end
                end
            end
        end

        @tileset_used = 'area02.png'
        @tileset = Gosu::Image.load_tiles(@window, "res/tls/#{@tileset_used}", 16, 16, false)

        @sel16 = Gosu::Image.new(@window, 'res/gui/sel16.png', false)
        @sel16_x = 16
        @sel16_y = 112
        @sel32 = Gosu::Image.new(@window, 'res/gui/sel32.png', false)
        @sel32_x = 672
        @sel32_y = 112

        @selected_tile = 0
        @current_layer = 0
        @ctrl_held = false
        @offset_x = 0
        @offset_y = 0
        @object_held = nil
        @active_mode = :map
        @objects = []

        @background = Gosu::Image.new(@window, 'res/gui/background.png', false)
        @grid = Gosu::Image.new(@window, 'res/gui/grid.png', false)
        @player_graphic = Gosu::Image.load_tiles(@window, 'res/spr/player_run_left.png', 32, 32, false)
    end

    def update
        if @window.button_down?(Gosu::MsLeft) && mouse_inside?(368, 1008, 160, 640)
            place_tile(@window.mouse_x, @window.mouse_y)
        end
    end

    def draw
        @background.draw(0, 0, 0)

        (0...@level.size).each do |l|
            (0...@level[l].size).each do |y|
                (0...@level[l][y].size).each do |x|
                    next unless x < 40 && y < 30

                    tx = 368 + (x * 16)
                    ty = 160 + (y * 16)
                    i = @level[l][y + @offset_y][x + @offset_x]
                    if l == @current_layer
                        @tileset[i].draw(tx, ty, 1 + l) unless i.nil? || i == 0
                    else
                        @tileset[i].draw(tx, ty, 1 + l, 1.0, 1.0, Gosu::Color.new(160, 255, 255, 255)) unless i.nil? || i == 0
                    end
                end
            end
        end

        (0...@tileset.size).each do |i|
            tx = 16 + ((i % 20) * 16)
            ty = 112 + ((i / 20) * 16)
            @tileset[i].draw(tx, ty, 1)
        end

        @sel16.draw(@sel16_x, @sel16_y, 5)
        @sel32.draw(@sel32_x, @sel32_y, 5)
        @grid.draw(368, 160, 5)

        frame = Gosu.milliseconds / 150 % @player_graphic.size
        @player_graphic[frame].draw(32, 352, 1)

        (0...@objects.size).each do |i|
            case @objects[i][0]
            when :player
                frame = Gosu.milliseconds / 150 % @player_graphic.size
                rx = @objects[i][1] - (@offset_x * 16) + 368
                ry = @objects[i][2] - (@offset_y * 16) + 160
                next if rx < 368 || rx > 1008 - 32 || ry < 160 || ry > 640 - 32
                @player_graphic[frame].draw(rx, ry, 6)
            end
        end

        @player_graphic[0].draw(@window.mouse_x, @window.mouse_y, 10) if @object_held == :player
    end

    def button_down(id)
        click if id == Gosu::MsLeft
        increase_offset if id == Gosu::MsWheelDown
        decrease_offset if id == Gosu::MsWheelUp
        @ctrl_held = true if id == Gosu::KbLeftControl
        increase_offset if id == Gosu::KbDown
        decrease_offset if id == Gosu::KbUp
        increase_offset(true) if id == Gosu::KbRight
        decrease_offset(true) if id == Gosu::KbLeft
    end

    def button_up(id)
        @ctrl_held = false if id == Gosu::KbLeftControl
    end

    def click
        if mouse_inside?(16, 336, 112, 304)
            select_tile(@window.mouse_x, @window.mouse_y)
        elsif mouse_inside?(368, 1008, 160, 640)
            case @active_mode
            when :map
                place_tile(@window.mouse_x, @window.mouse_y)
            when :objects
                place_object(@window.mouse_x, @window.mouse_y)
            end
        elsif mouse_inside?(672, 704, 112, 144)
            @current_layer = 0
            @sel32_x = 672
        elsif mouse_inside?(720, 752, 112, 144)
            @current_layer = 1
            @sel32_x = 720
        elsif mouse_inside?(32, 64, 352, 384)
            select_object(:player)
        elsif mouse_inside?(560, 592, 112, 144)
            save
        end
    end

    def select_tile(x, y)
        @active_mode = :map
        tx = ((x - 16) / 16).floor
        ty = ((y - 112) / 16).floor
        i = tx + (ty * 20)
        @sel16_x = (tx * 16) + 16
        @sel16_y = (ty * 16) + 112
        @selected_tile = i
    end

    def place_tile(x, y)
        tx = ((x - 368) / 16).floor
        ty = ((y - 160) / 16).floor
        @level[@current_layer][ty + @offset_y][tx + @offset_x] = @selected_tile
    end

    def select_object(object)
        @object_held = object
        @active_mode = :objects
        @sel32_x = 768
    end

    def place_object(x, y)
        if @object_held == :player
            (0...@objects.size).each do |i|
                @objects.delete_at(i) if !@objects[i].nil? && @objects[i][0] == :player
            end
        end

        rx = x + (@offset_x * 16) - 368
        ry = y + (@offset_y * 16) - 160
        @objects << [@object_held, rx, ry]

        @object_held = nil if @object_held == :player
    end

    def increase_offset(forced = false)
        if @ctrl_held || forced
            @offset_x += 1 if @offset_x < @level[0][0].size - 40
        else
            @offset_y += 1 if @offset_y < @level[0].size - 30
        end
    end

    def decrease_offset(forced = false)
        if @ctrl_held || forced
            @offset_x -= 1 if @offset_x > 0
        else
            @offset_y -= 1 if @offset_y > 0
        end
    end

    def save
        file = File.new('dat/001.map', 'w+')
        Marshal.dump(@tileset_used, file)
        Marshal.dump(@level, file)
        Marshal.dump(@objects, file)
        file.close
    end

    def mouse_inside?(x1, x2, y1, y2)
        @window.mouse_x.between?(x1, x2) && @window.mouse_y.between?(y1, y2)
    end
end
