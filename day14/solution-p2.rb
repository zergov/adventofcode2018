scoreboard = [3, 7]
elfs = [0, 1]

while scoreboard.length <= 25_000_000
  # create the new receipe
  created = elfs.map {|index| scoreboard[index]}.reduce(:+)
  # add receipe to scoreboard
  scoreboard.push(*(created.to_s.split('').map(&:to_i)))
  # update elfs index
  elfs.map! {|index| (index + scoreboard[index] + 1) % scoreboard.size }
end

p scoreboard.map(&:to_s).join =~ /074501/
