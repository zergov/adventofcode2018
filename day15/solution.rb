#!/usr/bin/env ruby
require './map'

input = File.readlines('input.example')
map = Map.new(input)

units = []
map.height.times do |y|
  map.width.times do |x|
    position = [x, y]
    cell_type = input[y][x]
    units << Unit.new(cell_type, position) if cell_type == "G" || cell_type == "E"
  end
end

# define action order
units.sort_by {|u| u.y * 999 + u.x}.each do |unit|
  enemy_type = unit.race == :goblin ? :elf : :goblin
  enemies = units.select {|enemy| enemy.race == enemy_type }

  # find adjacents spot of all enemies
  # if spots?
  #   move to closest
  # else
  #   end turn
  #
  #
end
