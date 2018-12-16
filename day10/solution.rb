#!/usr/bin/env ruby

stars = File.readlines('input.txt').map do |line|
  position, velocity = line.split('>')
  position = position.split.map {|x| x[/-?\d+/]}.compact.map(&:to_i)
  velocity = velocity.split.map {|x| x[/-?\d+/]}.compact.map(&:to_i)

  { position: position, velocity: velocity }
end

width = height = 150

# do some recon
# Check the smallest bounding box that contain all the stars
# bounds = []
# avgxs = []
# avgys = []
# 20000.times do |n|
  # newxs = stars.map do |star|
    # x, y = star[:position]; vx, vy = star[:velocity]
    # x + n * vx
  # end

  # newys = stars.map do |star|
    # x, y = star[:position]; vx, vy = star[:velocity]
    # y + n * vy
  # end

  # minx = newxs.min
  # maxx = newxs.max
  # miny = newys.min
  # maxy = newys.max

  # avgxs << {n => newxs.inject(:+) / newxs.size}
  # avgys << {n => newys.inject(:+) / newys.size}
  # bounds << {n => maxx - minx + maxy - miny}
# end

# second, bound = bounds.min_by {|bound| bound.values.first}.to_a.first # {10027 => 70}
# puts "min bound spot at #{second}: bound = #{bound}"
# puts "avgx: #{avgxs[second]}, avgy: #{avgys[second]}" # 172, 136

# following the recon, im playing with the time near the smallest bounding box, and checking near the average X and Y
time = 10027
avgx = 172
avgy = 136
10.times do |n|
  second = time + n - 5  # - (10 / 2)
  puts second # copy pasta this time when you see the words in your shell

  grid = Array.new(height).map {|x| Array.new(width).map { '.' }}
  stars.each do |star|
    x, y = star[:position]
    vx, vy = star[:velocity]

    x -= 80 # parce que c'est genre la moitié de 172 pis 136 lol
    y -= 80

    grid[y + second * vy][x + second * vx] = '#'
  end

  # just check your console
  grid.each {|row| p row }
  puts ""
end

