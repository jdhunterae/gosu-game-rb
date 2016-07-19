class Parser
    def parse_data(width, height)
        level = []
        layer0_raw = File.read('res/cnf/layer0.csv')
        layer1_raw = File.read('res/cnf/layer1.csv')

        layer0_data = layer0_raw.scan(/\d+/)
        layer1_data = layer1_raw.scan(/\d+/)

        layer0_data.collect!(&:to_i)
        layer1_data.collect!(&:to_i)

        level[0] = []
        level[1] = []
        (0...height).each do |y|
            level[0][y] = []
            level[1][y] = []
            (0...width).each do |x|
                level[0][y][x] = layer0_data[y * width + x] - 1
                level[0][y][x] = 0 if level[0][y][x] > 999 || level[0][y][x] < 0

                level[1][y][x] = layer1_data[y * width + x] - 1
                level[1][y][x] = 0 if level[0][y][x] > 999 || level[0][y][x] < 0
            end
        end

        level
    end
end
