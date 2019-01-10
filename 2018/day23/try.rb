# https://adventofcode.com/2018/day/23

class Try
  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end

  #
  # Part 1
  #

  def bots
    @bots ||= File.open(filename).map do |line|
      x, y, z, r = line.scan(/-?\d+/).map(&:to_i)
      { x: x, y: y, z: z, r: r }
    end
  end

  def strongest
    bots.each_with_object({ r: 0 }) do |bot, strongest|
      strongest.merge!(bot) if bot[:r] > strongest[:r]
    end
  end

  def in_range(origin)
    bots.select { |bot| distance(origin, bot) <= origin[:r] }
  end

  #
  # Part 2
  #

  def most_probable
    pick_most_probable(all_probables)
  end

  def all_probables(scale = 1)
    hash = Hash.new(0)

    # min_x = min(:x) * scale
    # max_x
    # min_y
    # max_y
    # min_z
    # max_z

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

    hash
  end

  def pick_most_probable(probables)
    winner = { score: 0, distance: 0 }

    probables.each do |origin, score|
      higher_score = score > winner[:score]
      same_score = score == winner[:score]

      distance = origin[:x] + origin[:y] + origin[:z]
      closer = distance < winner[:distance]

      if higher_score || (same_score && closer)
        winner.merge!(origin).merge!(score: score, distance: distance)
      end
    end

    winner
  end

  # Helpers

  def distance(origin, destination)
    dx = (origin[:x] - destination[:x]).abs
    dy = (origin[:y] - destination[:y]).abs
    dz = (origin[:z] - destination[:z]).abs
    dx + dy + dz
  end

  def max(symbol)
    @max ||= {}
    return @max[symbol] if @max[symbol]

    @max[symbol] = bots.each_with_object({ symbol => 0 }) do |bot, obj|
      obj[symbol] = bot[symbol] if bot[symbol] > obj[symbol]
    end[symbol]
  end

  def min(symbol)
    @min ||= {}
    return @min[symbol] if @min[symbol]

    @min[symbol] = bots.each_with_object({ symbol => 0 }) do |bot, obj|
      obj[symbol] = bot[symbol] if bot[symbol] < obj[symbol]
    end[symbol]
  end
end

# Part 1
# try = Try.new('input_a.txt')
# p try.bots
# p try.strongest
# p try.in_range(try.strongest).size

# Part 2
try = Try.new('input_b.txt')
# p try.all_probables.size
# p try.pick_most_probable(try.all_probables)
p try.most_probable
