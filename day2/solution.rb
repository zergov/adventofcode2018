def part1
  duos = 0
  triples = 0
  File.readlines('input.txt').each do |line|
    counts = {}
    counts.default = 0

    line.each_char {|char| counts[char] += 1 }
    duos += 1 if counts.values.include?(2)
    triples += 1 if counts.values.include?(3)
  end

  return duos * triples
end

def part2
  lines = File.readlines('input.txt')

  lines.each do |lineA|
    lines.each do |lineB|
      unless lineA == lineB
        nomatch_count = 0
        lineA.each_char.with_index do |charA, i|
          nomatch_count += 1 unless charA == lineB[i]
        end

        if nomatch_count <= 1
          return lineA.split('')
            .zip(lineB.split(''))
            .select {|a, b| a == b}
            .map {|a, b| a }
            .join('')
        end
      end
    end
  end
end

puts "Answer part1: #{part1}"
puts "Answer part2: #{part2}"
