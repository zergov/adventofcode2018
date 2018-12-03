require 'set'

class Claim
  attr_accessor :id, :left, :top, :width, :height

  def initialize(line)
    parts = line.split(' ')
    @id = parts[0].sub!('#', '')
    @left = parts[2].split(',')[0].to_i
    @top = parts[2].split(',')[1].sub!(':', '').to_i
    @width = parts[3].split('x')[0].to_i
    @height = parts[3].split('x')[1].to_i
  end
end

grid = []
(0..1400).each do
  row = []
  (0..1400).each do
    row << '.'
  end
  grid << row
end


ids = Set.new
overlapped = Set.new
File.readlines('input.txt').each do |line|
  claim = Claim.new(line)
  ids.add(claim.id)

  claim.width.times do |w|
    claim.height.times do |h|
      if grid[claim.top + h][claim.left + w] == '.'
        grid[claim.top + h][claim.left + w] = claim.id
      else
        overlapped.add(claim.id)
        overlapped.add(grid[claim.top + h][claim.left + w])
        grid[claim.top + h][claim.left + w] = 'x'
      end
    end
  end
end

count = 0
grid.each do |row|
  row.each do |cell|
    count += 1 if cell == 'x'
  end
end

puts "part1: #{count}"
puts "part2: #{(ids - overlapped).first}"
