def dist(a, b)
  xa, ya = a
  xb, yb = b
  (xa - xb).abs + (ya - yb).abs
end

coordinates = {}
File.readlines('input.txt').each.with_index do |coord, index|
  name = index.to_s
  coordinate = coord.split(',').map(&:strip).map(&:to_i)
  coordinates[name] = coordinate
end

size = 500
grid = Array.new(size).map { Array.new(size).map {'.'} }

size.times do |y|
  size.times do |x|
    closests = coordinates
      .map {|name, coordinate| [name, dist(coordinate, [x, y])] }
      .group_by {|name, distance| distance }
      .sort

    if closests.first.last.size >= 2
      grid[y][x] = '.'
    else
      grid[y][x] = closests.first.last.first.first.downcase
    end
  end
end

infinites = []
infinites << grid[0].map(&:itself).map(&:downcase)
infinites << grid[size - 1].map(&:itself).map(&:downcase)
infinites << size.times.to_a.map {|n| grid[n][0] }.map(&:itself).map(&:downcase)
infinites << size.times.to_a.map {|n| grid[n][size - 1] }.map(&:itself).map(&:downcase)
infinites = infinites.flatten.select {|x| x != '.' }.uniq


puts "coordinates:"
p coordinates

puts "infinites:"
p infinites

answer = grid
  .flatten
  .map(&:downcase)
  .select {|x| x != '.' && !infinites.include?(x) }
  .group_by(&:itself)
  .map {|k, v| [k, v.size]}
  .sort_by {|k, v| -v}.first.last

puts "p1 answer: #{answer}"
