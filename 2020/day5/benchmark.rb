ONES = ['B', 'R']

BINARY_MAP = {
  'F' => 0,
  'B' => 1,
  'R' => 1,
  'L' => 0,
}

def generate
  100_000.times.map do
    10.times.map { BINARY_MAP.keys[rand(4)] }.join
  end
end

def tom(code)
  num = 0
  code.size.times do |i|
    num <<= 1
    num += 1 if ONES.include?(code[i])
  end
  num
end

def angel(code)
  code.gsub(/[FL]/, '0').gsub(/[BR]/, '1').to_i(2)
end

def jason(code)
  code.chars.map { |char| BINARY_MAP[char] }.join.to_i(2)
end

def time(method, codes)
  t = Time.now
  codes.each { |code| send(method, code) }
  p [method, Time.now - t]
end

codes = generate
p [:tom, :angel, :jason].map { |method| send(method, 'FBFBFFFLLL') }
time(:tom, codes)
time(:angel, codes)
time(:jason, codes)
