#!/usr/bin/env ruby

class Nanobot
  attr_accessor :position, :radius

  def initialize(position, radius)
    @position = position
    @radius = radius
  end
end

def distance(a, b)
  xa, ya, za = a
  xb, yb, zb = b
  (xa - xb).abs + (ya - yb).abs + (za - zb).abs
end

nanobots = File.readlines('input.txt').map do |line|
  position = line.match(/<(.*?)>/).captures[0].split(',').map(&:to_i)
  radius = line.split('=').last.strip.to_i
  Nanobot.new(position, radius)
end

strongest = nanobots.reduce {|max, nanobot| max.radius > nanobot.radius ? max : nanobot}

xs = nanobots.map {|n| n.position[0] }
ys = nanobots.map {|n| n.position[1] }
zs = nanobots.map {|n| n.position[2] }

p [xs.min, xs.max]
p [ys.min, ys.max]
p [zs.min, zs.max]

p (xs.min - xs.max).abs
p (ys.min - ys.max).abs
p (zs.min - zs.max).abs

# p1 = nanobots
  # .select {|nanobot| distance(nanobot.position, strongest.position) <= strongest.radius }
  # .size
# puts "part1: #{p1}"



