#!/usr/bin/env ruby

height = width = 50
area = File.readlines('input.txt').map(&:strip)

10.times do
  newarea = Array.new(height).map { Array.new(width) }
  height.times do |y|
    width.times do |x|
      adjacents = [
        [x - 1, y - 1], [x, y - 1], [x + 1, y - 1],
        [x - 1, y], [x + 1, y],
        [x - 1, y + 1], [x, y + 1], [x + 1, y + 1],
      ]
        .select {|(x, y)| y >= 0 && y < height && x >= 0 && x < width}
        .map {|(x, y)| area[y][x] }

      case area[y][x]
      when "."
        newarea[y][x] = adjacents.count('|') >= 3 ? '|' : '.'
      when "|"
        newarea[y][x] = adjacents.count('#') >= 3 ? '#' : '|'
      when "#"
        newarea[y][x] = adjacents.count('#') >= 1 && adjacents.count('|') >= 1 ? '#' : '.'
      end
    end
  end

  area = newarea
end

wood = area.flatten.count('|')
lumbers = area.flatten.count('#')
puts wood * lumbers
