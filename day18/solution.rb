#!/usr/bin/env ruby

def simulate(minutes)
  height = width = 50
  area = File.readlines('input.txt').map(&:strip)

  minutes.times do |n|
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
  wood * lumbers
end

puts "part1: #{simulate(10)}"

# For part2, i ran a simulation for 5000 and moved all the results in a file.

# i went on https://plot.ly/create/#/
# created a plot of the values and found that it becomes a wave after value 532 (starting from 0)
# peak of 220785
# wave length = |532 - 560| = 28 minutes
#
# which means: after min 533, formula is:
# y = results[minute % 28]

results = [
  220785,
  219708,
  216804,
  214271,
  211552,
  205771,
  204863,
  199386,
  196860,
  192718,
  193438,
  189090,
  190568,
  190080,
  191649,
  190314,
  193966,
  193781,
  196876,
  197276,
  202722,
  201000,
  206040,
  206180,
  212711,
  214368,
  218680,
  217448,
]
puts "part2: #{results[1000000000 % results.size - 1]}"
