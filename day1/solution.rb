require 'set'

def part1
  return File.readlines('input.txt').inject(0) {|sum, n| sum + n.to_i}
end

def part2
  duplicates = Set[0]
  frequency = 0

  while true do
    File.readlines('input.txt').each do |line|
      frequency += line.to_i
      return frequency unless duplicates.add?(frequency)
    end
  end
end

puts "Answer part1: #{part1}"
puts "Answer part2: #{part2}"
