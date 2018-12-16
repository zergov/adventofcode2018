#!/usr/bin/env ruby

serial = File.read('input.txt').to_i

grid_size = 300
grid = Array.new(grid_size).map.with_index do |row, i|
  Array.new(grid_size).map.with_index do |col, ii|
    y = i + 1
    x = ii + 1

    rack_id = x + 10
    power_level = (rack_id * y) + serial
    power_level = power_level * rack_id
    power_level = (power_level / 100).to_s.split('').last.to_i
    power_level - 5
  end
end

top_rights = {}
grid.each.with_index do |row, y|
  row.each.with_index do |col, x|
    if x + 3 < grid_size && y + 3 < grid_size
      top_right = [x, y]
      total = 0
      3.times do |n|
        3.times do |m|
          total += grid[y + n][x + m]
        end
      end

      top_rights[top_right] = total
    end
  end
end

p top_rights.max_by {|k, v| v}.first.map {|coord| coord + 1}
