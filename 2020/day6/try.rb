#
# Part 1
#

# group = []
# count = 0
#
# File.open('input.txt').each do |line|
#   if line == "\n"
#     count += group.flatten.uniq.count
#     group = []
#     next
#   end
#
#   group << line.chomp.chars
# end
#
# p count + group.flatten.uniq.count

#
# Part 2
#

group = {}
count = 0
total = 0

def tally_group(hash, num)
  hash.values.count { |value| value == num }
end

File.open('input.txt').each do |line|
  if line == "\n"
    total += tally_group(group, count)
    group = {}
    count = 0
    next
  end

  line.chomp.chars.each do |char|
    group[char] ||= 0
    group[char] += 1
  end
  count += 1
end

p total += tally_group(group, count)
