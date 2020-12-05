BINARY_MAP = {
  'F' => 0,
  'B' => 1,
  'R' => 1,
  'L' => 0,
}

#
# Part 1
#

seat_ids = File.open('input.txt').map do |line|
  binary = line.chars.map { |char| BINARY_MAP[char] }.join
  binary.to_i(2)
end

p seat_ids.max

#
# Part 2
#

seat_ids.sort!.each.with_index do |seat_id, index|
  return p seat_id + 1 if (seat_id + 1) != seat_ids[index+1]
end
