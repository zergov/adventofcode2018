#!/usr/bin/env ruby

require 'set'

class Car
  attr_accessor :velocity, :position, :alive

  def initialize(char, position)
    @velocity = setup_velocity(char)
    @position = position
    @intersection_count = 0
    @alive = true
  end

  def draw
    case @velocity
    when [1, 0]
      ">"
    when [0, 1]
      "v"
    when [-1, 0]
      "<"
    when [0, -1]
      "^"
    end
  end

  def setup_velocity(char)
    case char
    when ">"
      [1, 0]
    when "v"
      [0, 1]
    when "<"
      [-1, 0]
    when "^"
      [0, -1]
    end
  end

  def update_velocity(char)
    @velocity = 
      case char
      when "/"
        if @velocity == [-1, 0]
          [0, 1] 
        elsif @velocity == [0, 1]
          [-1, 0] 
        elsif @velocity == [1, 0]
          [0, -1] 
        elsif @velocity == [0, -1]
          [1, 0] 
        end
      when "\\"
        if @velocity == [-1, 0]
          [0, -1] 
        elsif @velocity == [0, 1]
          [1, 0] 
        elsif @velocity == [1, 0]
          [0, 1] 
        elsif @velocity == [0, -1]
          [-1, 0] 
        end
      when "-"
        @velocity
      when "|"
        @velocity
      when "+"
        # TODO: apply custom logic!
        if @intersection_count % 3 == 0
          [@velocity[1], @velocity[0] * -1]
        elsif @intersection_count % 3 == 1
          @velocity
        elsif @intersection_count % 3 == 2
          [@velocity[1] * -1, @velocity[0]]
        end
      end
    
    # increment the intersection count if we hit an intersection
    @intersection_count += 1 if char == "+"
  end
end

lines = File.readlines('input.txt').map(&:chomp)
width = lines.first.size
height = lines.size
car_chars = [">", "v", "^", "<"]

# Create the road
cars = []
road = Array.new(height).map {|row| Array.new(width) }
height.times do |row|
  width.times do |col|
    cell = lines[row][col]

    if car_chars.include?(cell)
      car = Car.new(cell, [col, row])
      cars << car
      if car.velocity == [0, 1] || car.velocity == [0, -1]
        road[row][col] = "|"
      else
        road[row][col] = "-"
      end
    else
      road[row][col] = cell
    end
  end
end

# simulation
while true do
  # puts "ticking"
  # debug_road = road.map(&:dup)
  # debug_road.each.with_index do |row, i|
    # cars_to_show = cars.select { |car| car.position[1] == i && car.alive }
    # cars_to_show.each {|car| row[car.position[0]] = car.draw }
    # puts row.join
  # end
  # puts ""
  # puts ""

  # p cars.map(&:position)

  # Carts all move at the same speed;
  # they take turns moving a single step at a time.
  # They do this based on their current location: carts on the top row move first (acting from left to right),
  # then carts on the second row move (again from left to right), then carts on the third row, and so on.
  # moved = Set.new
  cars.sort_by! {|car| [car.position[1], car.position[0]]}
  cars.each do |car|
    next unless car.alive
    
    x, y = car.position
    vx, vy = car.velocity

    # check for colisions
    colision = cars.find {|car2| (car2.position == car.position) && car2.alive && car2 != car }
    if colision
      p colision
      puts "crash"
      # p colision.position
      # p car.position
      # puts "printing colision details"
      # p colision
      car.alive = false
      colision.alive = false

      alived = cars.select {|car| car.alive}
      # puts "printing alived car"
      puts alived.size
      # p alived
      if alived.size == 1
        p alived.first.position
        raise Error
      end
      next
    end

    # move the car
    car.position = [x + vx, y + vy]

    # calculate new velocity
    x, y = car.position
    new_position = road[y][x]
    car.update_velocity(new_position)
  end
end
