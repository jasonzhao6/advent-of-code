REQUIRED = [
  'byr', # (Birth Year)
  'iyr', # (Issue Year)
  'eyr', # (Expiration Year)
  'hgt', # (Height)
  'hcl', # (Hair Color)
  'ecl', # (Eye Color)
  'pid', # (Passport ID)
  # 'cid', # (Country ID)
]

#
# Part 1
#
#
# count = 0
# hash = {}
#
# File.open('input.txt').each do |line|
#   if line == "\n"
#     count += 1 if REQUIRED.all? { |key| hash.key?(key) }
#     hash = {}
#     next
#   end
#
#   line.split(' ').each do |key_value|
#     key, value = key_value.split(':')
#     hash[key] = value
#   end
# end
#
# count += 1 if REQUIRED.all? { |key| hash.key?(key) }
# p count

#
# Part 2
#

EYE_COLORS = %w[amb blu brn gry grn hzl oth]

def check(passport)
  return false unless REQUIRED.all? { |key| passport.key?(key) }

  byr = passport['byr'].to_i
  return false unless byr >= 1920 && byr <= 2002

  iyr = passport['iyr'].to_i
  return false unless iyr >= 2010 && iyr <= 2020

  eyr = passport['eyr'].to_i
  return false unless eyr >= 2020 && eyr <= 2030

  hgt = passport['hgt']
  hgt_i = hgt.to_i
  case hgt[-2..-1]
  when 'cm'
    return false unless hgt_i >= 150 && hgt_i <= 193
  when 'in'
    return false unless hgt_i >= 59 && hgt_i <= 76
  else
    return false
  end

  hcl = passport['hcl']
  return false unless hcl =~ /^#[0-9a-f]{6}$/

  ecl = passport['ecl']
  return false unless EYE_COLORS.include?(ecl)

  pid = passport['pid']
  return false unless pid =~ /^[0-9]{9}$/

  true
end

count = 0
hash = {}

File.open('input.txt').each do |line|
  if line == "\n"
    count += 1 if check(hash)
    hash = {}
    next
  end

  line.split(' ').each do |key_value|
    key, value = key_value.split(':')
    hash[key] = value
  end
end

count += 1 if check(hash)
p count
