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
    previous = grid[y][x]
    size = 1
    while x + size < grid_size && y + size < grid_size do
      key = [x, y, size]

      xx = x + size
      yy = y + size

      total_col = 0
      total_row = 0
      (size + 1).times { |n| total_col += grid[y + n][xx] }
      (size + 1).times { |n| total_row += grid[yy][x + n] }

      total = previous + total_col + total_row
      total = total - grid[yy][x + size] if size > 0
      top_rights[key] = total
      previous = total

      size += 1
    end
    # puts "max size was: #{size}"
  end
end

# top_rights.each { |coords| p coords }

# p top_rights.size
# grid.each {|row| p row}
p top_rights.max_by {|k, v| v}.first.map {|i| i + 1 }
