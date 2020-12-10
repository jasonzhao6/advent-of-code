# https://adventofcode.com/2018/day/23

# A relatively fast brute force solution. Part 2 takes ~2 min on an '18 13" MBP.
# Speed improvement comes from solving each significant digit separately.
class Try
  # Configs
  REACH = 10 + 5 * 2 # 10 covers the next digit; 5 * 2 covers rounding errors in both directions.
  STARTING_SCALE = 1_000_000_000.0 # Take the biggest number from input, and round up a digit.

  # Constants
  BOTH_DIRECTIONS = 2
  CENTER = { x: 0, y: 0, z: 0 }
  FINAL_SCALE = 1
  TEN_TIMES = 10

  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end

  #
  # Part 1
  #

  # Memoize all bots read from file.
  def bots
    @bots ||= File.open(filename).map do |line|
      x, y, z, r = line.scan(/-?\d+/).map(&:to_i)
      { x: x, y: y, z: z, r: r }
    end
  end

  # Find bot with largest radius.
  def strongest
    bots.each_with_object({ r: 0 }) do |bot, strongest|
      strongest.merge!(bot) if bot[:r] > strongest[:r]
    end
  end

  # Given a bot, find all other bots within its radius.
  def in_range(origin)
    bots.select { |bot| distance(origin, bot) <= origin[:r] }
  end

  #
  # Part 2
  #

  # Brute force range score for every coordinate within bounds.
  def all_probables(
    min_x = min(:x),
    max_x = max(:x),
    min_y = min(:y),
    max_y = max(:y),
    min_z = min(:z),
    max_z = max(:z),
    local_bots = bots
  )
    range_scores = Hash.new(0)

    (min_x..max_x).each do |x|
      (min_y..max_y).each do |y|
        (min_z..max_z).each do |z|
          coordinate = { x: x, y: y, z: z }
          local_bots.each do |bot|
            bot_in_range = distance(coordinate, bot) <= bot[:r]
            range_scores[coordinate] += 1 if bot_in_range
          end
        end
      end
    end

    range_scores
  end

  # Pick out coordinate with highest score and shortest distance to CENTER.
  def pick_most_probable(probables)
    winner = { range_score: 0, distance: 0 }

    probables.each do |coordinate, range_score|
      higher_range_score = range_score > winner[:range_score]
      same_range_score = range_score == winner[:range_score]

      distance = distance(CENTER, coordinate)
      closer = distance < winner[:distance]

      if higher_range_score || (same_range_score && closer)
        winner.merge!(range_score: range_score, distance: distance)
        winner.merge!(coordinate)
      end
    end

    winner
  end

  # Improve brute force speed by solving each significant digit separately.
  def most_probable_at_scale
    scale = STARTING_SCALE
    min_x = resize(min(:x), scale)
    max_x = resize(max(:x), scale)
    min_y = resize(min(:y), scale)
    max_y = resize(max(:y), scale)
    min_z = resize(min(:z), scale)
    max_z = resize(max(:z), scale)
    resized_bots = resize_bots(scale)

    until scale == FINAL_SCALE do
      pick = pick_most_probable(
        all_probables(min_x, max_x, min_y, max_y, min_z, max_z, resized_bots)
      )

      scale /= TEN_TIMES; p ['scale', scale]
      min_x, min_y, min_z = [:x, :y, :z].map { |key| pick[key] * TEN_TIMES }
      max_x, max_y, max_z = [min_x, min_y, min_z].map { |value| value + REACH }
      resized_bots = resize_bots(scale)
    end

    pick_most_probable(
      all_probables(min_x, max_x, min_y, max_y, min_z, max_z, resized_bots)
    )
  end

  #
  # Helpers
  #

  # Calculate manhattan distance between two coordinates.
  def distance(origin, destination)
    dx = (origin[:x] - destination[:x]).abs
    dy = (origin[:y] - destination[:y]).abs
    dz = (origin[:z] - destination[:z]).abs
    dx + dy + dz
  end

  # Find max value of given symbol across all bots.
  def max(symbol)
    @max ||= {}
    return @max[symbol] if @max[symbol]

    @max[symbol] = bots.each_with_object({ symbol => 0 }) do |bot, obj|
      obj[symbol] = bot[symbol] if bot[symbol] > obj[symbol]
    end[symbol]
  end

  # Find min value of given symbol across all bots.
  def min(symbol)
    @min ||= {}
    return @min[symbol] if @min[symbol]

    @min[symbol] = bots.each_with_object({ symbol => 0 }) do |bot, obj|
      obj[symbol] = bot[symbol] if bot[symbol] < obj[symbol]
    end[symbol]
  end

  # Resize integer using given scale conservatively:
  # E.g 5.5 becomes 5 to be conservative.
  # E.g -5.5 becomes -5 to be conservative.
  def resize(integer, scale)
    integer > 0 ? (integer / scale).floor : (integer / scale).ceil
  end

  # Resize bot coordinates conservatively and radius liberally.
  def resize_bots(scale)
    bots.map do |bot|
      {
        x: resize(bot[:x], scale),
        y: resize(bot[:y], scale),
        z: resize(bot[:z], scale),
        r: resize(bot[:r], scale) + (scale > FINAL_SCALE ? BOTH_DIRECTIONS : 0),
      }
    end
  end
end

# Part 1
# try = Try.new('input_a.txt')
# p try.bots
# p try.strongest
# p try.in_range(try.strongest).size

# Part 2
try = Try.new('another.txt')
# p try.all_probables.size
# p try.pick_most_probable(try.all_probables)
p try.most_probable_at_scale
