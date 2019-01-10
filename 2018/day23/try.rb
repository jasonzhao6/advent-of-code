# https://adventofcode.com/2018/day/23

class Try
  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end

  def strongest
    bots.each_with_object({ r: 0 }) do |bot, strongest|
      strongest.merge!(bot) if bot[:r] > strongest[:r]
    end
  end

  def in_range(origin)
    bots.select { |bot| distance(origin, bot) <= origin[:r] }
  end

  def most_probable
    hash = Hash.new(0)

    (min(:x)..max(:x)).each do |x|
      (min(:y)..max(:y)).each do |y|
        (min(:z)..max(:z)).each do |z|
          origin = { x: x, y: y, z: z }
          bots.each do |bot|
            hash[origin] += 1 if distance(origin, bot) <= bot[:r]
          end
        end
      end
    end

    hash.each_with_object(score: 0, distance: 0) do |(origin, score), winner|
      higher_score = score > winner[:score]
      same_score = score == winner[:score]

      distance = origin[:x] + origin[:y] + origin[:z]
      closer = distance < winner[:distance]

      if higher_score || (same_score && closer)
        winner.merge!(origin).merge!(distance: distance, score: score)
      end
    end
  end

  private

  def bots
    @bots ||= File.open(filename).map do |line|
      x, y, z, r = line.scan(/-?\d+/).map(&:to_i)
      { x: x, y: y, z: z, r: r }
    end
  end

  def distance(origin, destination)
    dx = (origin[:x] - destination[:x]).abs
    dy = (origin[:y] - destination[:y]).abs
    dz = (origin[:z] - destination[:z]).abs
    dx + dy + dz
  end

  def min(symbol)
    @min ||= {}
    return @min[symbol] if @min[symbol]

    @min[symbol] = bots.each_with_object({ symbol => 0 }) do |bot, obj|
      obj[symbol] = bot[symbol] if bot[symbol] < obj[symbol]
    end[symbol]
  end

  def max(symbol)
    @max ||= {}
    return @max[symbol] if @max[symbol]

    @max[symbol] = bots.each_with_object({ symbol => 0 }) do |bot, obj|
      obj[symbol] = bot[symbol] if bot[symbol] > obj[symbol]
    end[symbol]
  end
end

# Part 1
# try = Try.new('input_a.txt')
# p try.in_range(try.strongest).size

try = Try.new('input_b.txt')
p try.most_probable
