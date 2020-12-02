valid_count = 0

File.open('input.txt').each do |line|
  matches = line.match /(?<min>\d+)-(?<max>\d+) (?<char>[a-z]): (?<pwd>[a-z]+)/
  min = matches[:min].to_i
  max = matches[:max].to_i
  char = matches[:char]
  pwd = matches[:pwd]

  # Part 1
  # char_count = pwd.chars.count { |c| c == char }
  # valid_count += 1 if char_count >= min && char_count <= max.to_i

  # Part 2
  min -= 1
  max -= 1
  valid_count += 1 if (pwd[min] == char) ^ (pwd[max] == char)
end

puts valid_count
