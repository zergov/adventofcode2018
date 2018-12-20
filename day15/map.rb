require './unit'

class Map
  attr_reader :width, :height

  def initialize(definition)
    @width = definition.first.size
    @height = definition.size
    @grid = Array.new(height).map { Array.new(width) }
    height.times do |y|
      width.times do |x|
        cell = definition[y][x]
        if cell == "G" || cell == "E"
          @grid[y][x] = "."
        else
          @grid[y][x] = cell
        end
      end
    end
  end

  def draw
    puts @grid.map(&:join)
  end
end


