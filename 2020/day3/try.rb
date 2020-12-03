map = []

File.open('input.txt').each do |line|
  map << line.chomp * 100
end

#
# Part 1
#

cursor = 0
count = 0

map.each do |line|
  count += 1 if line[cursor] == '#'
  cursor += 3
end

#
# Part 2
#

counts = []

slope = [
  [1, 1],
  [3, 1],
  [5, 1],
  [7, 1],
  [1, 2],
]

slope.each do |x, y|
  cursor = 0
  count = 0

  map.each.with_index do |line, index|
    next if index.odd? && y == 2
    count += 1 if line[cursor] == '#'
    cursor += x
  end

  counts << count
end

p counts.reduce(:*)
