pattern = "074501"
scoreboard = [3, 7]
elfs = [0, 1]

until scoreboard.last(pattern.size).join == pattern do
  # create the new receipe
  created = elfs.map {|index| scoreboard[index]}.reduce(:+)
  # add receipe to scoreboard
  scoreboard = scoreboard.concat(created.to_s.split('').map(&:to_i))
  # update elfs index
  elfs = elfs.map {|index| (index + scoreboard[index] + 1) % scoreboard.size }
end

scoreboard.pop(pattern.size)
p scoreboard.size
