# https://adventofcode.com/2018/day/23

class Try
  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end

  def strongest
    return @strongest ||= bots.each_with_object({ r: 0 }) do |bot, strongest|
      strongest.merge!(bot) if bot[:r] > strongest[:r]
    end
  end

  def in_range(origin)
    @in_range ||= {}
    return @in_range[origin.to_s] if @in_range[origin.to_s]

    @in_range[origin.to_s] = bots.select do |bot|
      dx = (origin[:x] - bot[:x]).abs
      dy = (origin[:y] - bot[:y]).abs
      dz = (origin[:z] - bot[:z]).abs
      dt = dx + dy + dz

      dt <= origin[:r]
    end
  end

  def most_probable
    hash = {}

    (min(:x)..max(:x)).each do |x|
      (min(:y)..max(:y)).each do |y|
        (min(:z)..max(:z)).each do |z|
          hash[[x, y, z].join(',')] = 0
        end
      end
    end

    hash
  end

  private

  def bots
    return @bots ||= File.open(filename).map do |line|
      x, y, z, r = line.scan(/-?\d+/).map(&:to_i)
      { x: x, y: y, z: z, r: r }
    end
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

try = Try.new('input_a.txt')
p try.most_probable
