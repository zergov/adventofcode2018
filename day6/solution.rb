def dist(a, b)
  xa, ya = a
  xb, yb = b
  (xa - xb).abs + (ya - yb).abs
end

coordinates = {}
coordinates_points = {}
File.readlines('input.txt').each.with_index do |coord, index|
  name = (index + 65).chr
  coordinate = coord.split(',').map(&:strip).map(&:to_i)
  coordinates[coordinate] = name
  coordinates_points[name] = coordinate
end

p coordinates_points
p coordinates

size = 10
grid = Array.new(size).map { Array.new(size).map {'.'} }

size.times do |y|
  size.times do |x|
    coordinates.each do |(cx, cy), name|
      cell_coordinate_distance = dist([x, y],[cx, cy])

      # if current cell is a dot, claim that cell
      if grid[y][x] == '.'
        grid[y][x] = name.downcase
      elsif grid[y][x] == '*'
        next
      else
        other = grid[y][x].upcase   # else, this is already claimed by an other point
        cell_coordinate_other = dist([x,y], coordinates_points[other])

        # if the distance between the current cell and the coordinate we're checking
        # is smaller than the coordinate by which its already claimed, override
        # the other coordinate.
        if  cell_coordinate_distance < cell_coordinate_other
          grid[y][x] = name.downcase
        elsif cell_coordinate_distance == cell_coordinate_other
          grid[y][x] = '*'
        end
      end
    end
  end
end

coordinates.each do |(x, y), name|
  grid[y][x] = name
end

grid.each {|row| puts row.join}
