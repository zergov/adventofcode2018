class Map
  def initialize(definition)
    width = definition.first.size
    height = definition.size

    @grid = Array.new(height).map { Array.new(width) }
    height.times do |y|
      width.times { |x| @grid[y][x] = definition[y][x] }
    end
  end

  def draw
    puts @grid.map(&:join)
  end
end


