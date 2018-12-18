#!/usr/bin/env ruby

require 'set'

class Car
  attr_accessor :velocity, :position

  def initialize(char, position)
    @velocity = setup_velocity(char)
    @position = position
    @intersection_count = 0
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
tick = 0
while true do
  puts "starting tick #{tick}" if tick % 100 == 0
  # debug_road = road.map(&:dup)
  # debug_road.each.with_index do |row, i|
    # cars_to_show = cars.select { |car| car.position[1] == i }
    # cars_to_show.each {|car| row[car.position[0]] = car.draw }
    # puts row.join
  # end
  # puts ""
  # puts ""
  # cars.each {|car| p car.velocity}

  # p cars.map(&:position)

  # Carts all move at the same speed;
  # they take turns moving a single step at a time.
  # They do this based on their current location: carts on the top row move first (acting from left to right),
  # then carts on the second row move (again from left to right), then carts on the third row, and so on.
  moved = Set.new
  height.times do |row|
    # respect car movement priority
    cars_to_move = cars
      .select {|car| car.position[1] == row}    # find all car in this row, 
      .sort_by {|car| car.velocity[0]}          # sort them from left to right
      .select {|car| !moved.include?(car) }     # only take the ones that did not move this tick

    cars_to_move.each do |car|
      x, y = car.position
      vx, vy = car.velocity

      # move the car
      car.position = [x + vx, y + vy]

      # calculate new velocity
      x, y = car.position
      new_position = road[y][x]
      car.update_velocity(new_position)

      # add this car to the moved set
      moved << car
    end

    colisions = cars
      .group_by {|car| car.position }
      .select {|position, cars| cars.size > 1}

    if colisions.size > 0
      p colisions.keys.first
      raise Error
    end
  end

  tick += 1
end
