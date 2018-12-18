goal = File.read('input.txt').to_i
scoreboard = [3, 7]
elfs = [0, 1]

until scoreboard.size == goal + 10 do
  # create the new receipe
  created = elfs.map {|index| scoreboard[index]}.reduce(:+)
  # add receipe to scoreboard
  scoreboard = scoreboard + created.to_s.split('').map(&:to_i)
  # update elfs index
  elfs = elfs.map {|index| (index + scoreboard[index] + 1) % scoreboard.size }
end
p scoreboard.last(10).join
