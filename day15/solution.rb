#!/usr/bin/env ruby
require './map'

def simulate(attack)
  puts "Starting simulation with elf attack = #{attack}"
  input = File.readlines('input.txt')
  map = Map.new(input)

  units = []
  map.height.times do |y|
    map.width.times do |x|
      position = [x, y]
      cell_type = input[y][x]
      if cell_type == "E"
        units << Unit.new(cell_type, position, attack)
      elsif cell_type == "G"
        units << Unit.new(cell_type, position)
      end
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

      if units.select {|u| u.race == :elf }.any?(&:dead)
        return false
      end

      elfs, goblins = units.select(&:alive).partition {|u| u.race == :elf }
      if goblins.size == 0
        total_hp = elfs.reduce(0) {|sum, u| sum + u.hp}
        answer = total_hp * round
        answer1 = total_hp * (round+1)

        puts "total hp: #{total_hp}"
        puts "total round: #{round}"
        return [attack, "Game over, elfs win! answer: #{answer}, other answer: #{answer1}"]
      end
    end

    units.select!(&:alive)

    puts "after round: #{round}"
    map.draw(units)
    round += 1
  end
end

outcomes = {}
attacks = (18..20).to_a
low = 0
high = attacks.size - 1

while (low <= high)
  mid = (low + high) / 2

  simulation = simulate(attacks[mid])

  if simulation
    attack, outcome = simulation
    outcomes[attack] = outcome
  end

  if simulation
    high = mid - 1
  else
    low = mid + 1
  end
end

p outcomes.sort_by {|attack, _| attack}.first
