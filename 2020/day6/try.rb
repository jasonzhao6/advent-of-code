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
  answers = group.split("\n")
  answers.map { |answer| answer.chars }.reduce(:&).count
end

p counts.sum
