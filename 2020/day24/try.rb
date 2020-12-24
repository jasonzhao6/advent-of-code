require 'set'

class Program
  def initialize(input)
    @input = input

    @hashes = [{}, {}]
    @toggle = true
    @memo = Set.new
  end

  def cur
    @toggle ? @hashes[0] : @hashes[1]
  end

  def nex
    @toggle ? @hashes[1] : @hashes[0]
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

    cur[[x, y]] = !cur[[x, y]]
  end

  def p1
    @input.each do |line|
      parse(line)
    end

    p cur.values.count { |value| value }
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
    return if @memo.include?(xy)

    vals = nbors(xy).map { |xy| cur[xy] }
    count = vals.count { |value| value }

    if cur[xy]
      if count == 0 || count > 2
        nex[xy] = false # white
      else
        nex[xy] = true # black
      end
    else
      if count == 2
        nex[xy] = true # black
      else
        nex[xy] = false # white
      end
    end

    @memo.add(xy)
  end

  def round
    cur.each do |xy, _val|
      tile(xy)

      nbors(xy).each do |xy|
        tile(xy)
      end
    end

    @toggle = !@toggle
    @memo.clear
  end

  def p2
    100.times do |i|
      p i if i % 10 == 0
      round
    end

    p cur.values.count { |value| value }
  end
end

input = File.open('input.txt').read.split("\n")
program = Program.new(input)
program.p1
program.p2
