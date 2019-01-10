# https://adventofcode.com/2018/day/23

class Try
  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end

  def bots
    return @bots ||= File.open(filename).map do |line|
      x, y, z, r = line.scan(/-?\d+/).map(&:to_i)
      { x: x, y: y, z: z, r: r }
    end
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
end

# Part 1
# try = Try.new('input_a.txt')
# p try.in_range(try.strongest).size

try = Try.new('input.txt')
p try.in_range(try.strongest).size
