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

map.draw(units)
round = 0
loop do
  units.sort_by {|u| u.y * 1000 + u.x}.each do |unit|
    # p unit
    next if unit.dead

    enemy_race = unit.race == :goblin ? :elf : :goblin
    alived = units.select(&:alive)
    # p "alived"
    enemies = alived.select {|enemy| enemy.race == enemy_race }
    # p "enemies"

    in_range = enemies.select {|enemy| map.neighbors(unit.x, unit.y).include?(enemy.position)}
    # p "in_range"

    if in_range.empty?
      adjacents = enemies
        .map { |enemy| map.adjacents(enemy.x, enemy.y) }.flatten(1)
      # p "adjacents"

      paths = adjacents
        .map {|position| [position, map.path(unit.position, position, alived)]}
        .select { |position, paths| paths != nil && paths != [] }
        .to_h
      # p "paths"

      nearest = paths.map {|position, _| [position, paths[position].size]}
        .group_by {|pos, dist| dist}
        .sort_by {|key, _| key}
      # p "nearest"

      # if we have some spots to move to, try to move to that spot
      unless paths.empty?
        position = if !nearest.empty? && nearest.first.last.size > 1
          nearest.first.last.sort_by {|(x, y), _| y * 10000 + x}.first.first
        else
          nearest.first.last.first.first
        end

        newx, newy = map.direction_to_vector(paths[position].first)
        unit.position = [unit.x + newx, unit.y + newy]
      end
    end

    in_range = enemies.select {|enemy| map.neighbors(unit.x, unit.y).include?(enemy.position)}
    # p "in range"

    # attack if we're in range of someone
    unless in_range.empty?
      targets = in_range.sort_by(&:hp).group_by(&:hp).to_a.first.last

      # p in_range
      target = nil
      if targets.size > 1
        target = targets.sort_by {|u| u.y * 10000 + u.x}.first
      elsif targets.size == 1
        target = targets.first
      end

      unless target.nil?
        target.hp -= unit.attack_power
      end
    end
  end

  units.select!(&:alive)

  puts "after round: #{round}"
  map.draw(units)

  elfs, goblins = units.partition {|u| u.race == :elf }
  if elfs.size == 0
    answer = goblins.reduce(0) {|sum, u| sum + u.hp} * round
    puts round
    puts "Game over, goblins win! answer: #{answer}"
    exit
  elsif goblins.size == 0
    answer = elfs.reduce(0) {|sum, u| sum + u.hp} * round
    puts round
    puts "Game over, elfs win! answer: #{answer}"
    exit
  end

  round += 1
end
