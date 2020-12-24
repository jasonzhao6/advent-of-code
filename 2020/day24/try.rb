class Program
  def initialize(input)
    @input = input

    @curr = {}
    @next = {}
  end

  # Use complex numbers as a tuple to store x and y as `x + yi`.
  COMPLEX_NUMS = {
    'se' => 1 - 1i,
    'sw' => -1 - 1i,
    'ne' => 1 + 1i,
    'nw' => -1 + 1i,
    # Replace single-letter directions last to avoid misinterpreting double-letter ones.
    'e' => 2,
    'w' => -2,
  }

  def parse(line)
    COMPLEX_NUMS.each do |direction, num|
      line.gsub!(direction, "#{num} +")
    end

    xy = eval("#{line} 0")
    @curr[xy] = !@curr[xy]
  end

  def p1
    @input.each do |line|
      parse(line)
    end

    p @curr.values.count { |value| value }
  end

  def nbors(xy)
    COMPLEX_NUMS.values.map { |value| xy + value }
  end

  def tile(xy)
    return if @next[xy]

    vals = nbors(xy).map { |xy| @curr[xy] }
    count = vals.count { |value| value }

    if @curr[xy] && !(count == 0 || count > 2)
      @next[xy] = true
    elsif !@curr[xy] && count == 2
      @next[xy] = true
    end
  end

  def round
    @curr.each do |xy, _val|
      tile(xy)

      nbors(xy).each do |xy|
        tile(xy)
      end
    end

    @curr = @next
    @next = {}
  end

  def p2
    100.times do |i|
      p i if i % 10 == 0
      round
    end

    p @curr.values.count { |value| value }
  end
end

input = File.open('input.txt').read.split("\n")
program = Program.new(input)
program.p1
program.p2
