#
# Part 1
#

file = File.open('input.txt').read
groups = file.split("\n\n")
counts = groups.map do |group|
  answers = group.split("\n")
  answers.map { |answer| answer.chars }.flatten.uniq.count
end

p counts.sum

#
# Part 2
#

file = File.open('input.txt').read
groups = file.split("\n\n")
counts = groups.map do |group|
  hash = Hash.new(0)

  answers = group.split("\n")
  answers.each do |answer|
    answer.chars.each do |char|
      hash[char] += 1
    end
  end

  hash.values.count { |value| value == answers.count }
end

p counts.sum
