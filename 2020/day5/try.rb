BINARY_MAP = {
  'F' => 0,
  'B' => 1,
  'R' => 1,
  'L' => 0,
}

#
# Part 1
#

max = 0
seat_ids = []

File.open('input.txt').each do |line|
  binary = line.chars.map { |char| BINARY_MAP[char] }.join

  row = binary[0..6].to_i(2)
  col = binary[7..-1].to_i(2)

  seat_id = row * 8 + col
  seat_ids << seat_id
  max = seat_id if seat_id > max
end

#
# Part 2
#

min = 0

seat_ids.sort.each.with_index do |seat_id, index|
  min = seat_id if index == 0
  return p seat_id - 1 if seat_id.to_i != (index + min)
end
