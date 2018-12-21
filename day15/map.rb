require './unit'
require 'set'

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

  def adjacents(x, y)
    [
      [x, y + 1], [x, y - 1],
      [x + 1, y], [x - 1, y],
    ]
      .select {|x, y| x < @width && x >= 0 && y < @height && y >= 0 }
      .select {|x, y| @grid[y][x] == '.' }
  end

  def path(from, to)
    open = []
    closed = Set.new
    meta = {}

    root = from
    meta[root] = [nil, nil]
    open.unshift(root)

    until open.empty?
      position = open.shift

      if to == position
        return "found a path"
      end

      successors(position).each do |child, action|
        # next if child in closed
        #
        # unless open.include?(child)
        #   meta[child] = (position, action)
        #   open.unshift(child)
        # end
        #
        # closed.add(child)
        # qqhcose comme ca
      end
    end
  end

  private

  def successors(position)
    # return adjacents of position + action associated with it
  end
end


