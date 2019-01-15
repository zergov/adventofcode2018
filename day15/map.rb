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

  def draw(units = [])
    g = @grid.map.with_index do |row, y|
      row.map.with_index do |cell, x|
        units.find {|u| u.position == [x, y]} || cell
      end.join
    end

    puts g
  end

  def adjacents(x, y)
    neighbors(x, y)
      .select do |x, y|
        x < @width && x >= 0 && y < @height && y >= 0 && @grid[y][x] == '.'
      end
  end

  def path(from, to, units)
    open = []
    closed = Set.new([from])
    meta = {}

    meta[from] = [nil, nil]
    open << from

    until open.empty?
      position = open.shift

      return construct_path(position, meta) if to == position

      successors(position, units).each do |child, action|
        next if closed.include?(child)

        unless open.include?(child)
          meta[child] = [position, action]
          open << child
        end

        closed.add(child)
      end
    end
  end

  def direction_to_vector(direction)
    case direction
    when :up then [0, -1]
    when :down then [0, 1]
    when :left then [-1, 0]
    when :right then [1, 0]
    end
  end

  def neighbors(x, y)
    [
      [x, y + 1], [x, y - 1],
      [x + 1, y], [x - 1, y],
    ]
  end

  private

  def successors(position, units)
    x, y = position
    neighbors(x, y)
      .zip([:down, :up, :right, :left])
      .sort_by {|(x, y), _| y * 10000 + x}
      .select do |(x, y), _|
        inbound = x < @width && x >= 0 && y < @height && y >= 0
        available = @grid[y][x] == '.'
        occupied = units.any? {|u| u.position == [x, y]}
        inbound && available && !occupied
      end
  end

  def construct_path(state, meta)
    actions = []
    until meta[state][0] == nil
      state, action = meta[state]
      actions << action
    end
    actions.reverse
  end
end


