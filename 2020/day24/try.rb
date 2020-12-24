class Program
  def initialize(input)
    @input = input

    @curr = {}
    @next = {}
  end

  def parse(line)
    x = 0
    y = 0

    # e, se/a, sw/b, w, nw/c, ne/d;
    line = line.gsub('se', 'a').gsub('sw', 'b').gsub('nw', 'c').gsub('ne', 'd')
    line.split('').each do |char|
      case char
      when 'e'
        x += 1
      when 'a'
        x += 0.5
        y -= 0.5
      when 'b'
        x -= 0.5
        y -= 0.5
      when 'w'
        x -= 1
      when 'c'
        x -= 0.5
        y += 0.5
      when 'd'
        x += 0.5
        y += 0.5
      else
        raise '!'
      end
    end

    @curr[[x, y]] = !@curr[[x, y]]
  end

  def p1
    @input.each do |line|
      parse(line)
    end

    p @curr.values.count { |value| value }
  end

  def nbors(xy)
    x, y = xy
    [
      [x + 1, y],
      [x + 0.5, y - 0.5],
      [x - 0.5, y - 0.5],
      [x - 1, y],
      [x - 0.5, y + 0.5],
      [x + 0.5, y + 0.5]
    ]
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
