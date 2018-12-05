def reduce(poly)
  while true
    break poly if ('a'..'z').to_a.all? do |char|
      [
        poly.gsub!("#{char}#{char.upcase}", ''),
        poly.gsub!("#{char.upcase}#{char}", ''),
      ].none?
    end
  end
end

puts reduce(File.read('input.txt')).size

base = File.read('input.txt')
totals = ('a'..'z').to_a.map do |char|
  poly = base.dup
  poly.gsub!(char.downcase, '')
  poly.gsub!(char.upcase, '')
  reduce(poly).size
end

puts totals.min
