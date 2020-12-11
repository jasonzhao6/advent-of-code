require 'set'

#
# Part 1
#

# class Program
#   def initialize(input)
#     @input = input
#
#     @row_count = input.size
#     @col_count = input.first.size
#     @adj = {}
#   end
#
#   def adj(y, x)
#     key = "#{y},#{x}"
#     return @adj[key] if @adj[key]
#
#     grid = (-1..1).to_a.map do |yd|
#       (-1..1).to_a.map do |xd|
#         [y + yd, x + xd]
#       end
#     end.flatten(1)
#
#     @adj[key] = grid.select do |coord|
#       coord[0] >= 0 && coord[1] >= 0 &&
#         coord[0] < @row_count && coord[1] < @col_count &&
#         !(coord[0] == y && coord[1] == x)
#     end
#   end
#
#   def run
#     prev = Marshal.load(Marshal.dump(@input))
#
#     @row_count.times.with_index do |y|
#       @col_count.times.with_index do |x|
#         next if @input[y][x] == '.'
#
#         adjs = adj(y, x).map do |pair|
#           prev[pair[0]][pair[1]]
#         end
#
#         count = adjs.count { |adj| adj == '#' }
#
#         if count == 0
#           @input[y][x] = '#'
#         elsif count >= 4 && @input[y][x] == '#'
#           @input[y][x] = 'L'
#         end
#       end
#     end
#
#     if prev.to_s == @input.to_s
#       p @input.to_s.chars.count { |seat| seat == '#' }
#     else
#       run
#     end
#   end
# end
#
# input = File.open('input.txt').read.split("\n")
# program = Program.new(input)
#
# t = Time.now
# program.run
# p Time.now - t

#
# Part 2
#

class Program
  def initialize(input)
    @input = input

    @row_count = input.size
    @col_count = input.first.size
    @big_count = [@row_count, @col_count].max
    @adj = {}
  end

  def bound?(y, x)
    y >= 0 && x >= 0 && y < @row_count && x < @col_count
  end

  def adj(y, x)
    key = "#{y},#{x}"
    return @adj[key] if @adj[key]

    @adj[key] = (-1..1).to_a.map do |yd|
      (-1..1).to_a.map do |xd|
        next if yd == 0 && xd == 0
        @big_count.times.map.with_index do |i|
          next if i == 0
          y2 = y + yd * i
          x2 = x + xd * i
          next unless bound?(y2, x2)
          [y2, x2]
        end.compact
      end.compact
    end.flatten(1)
  end

  def run
    prev = Marshal.load(Marshal.dump(@input))

    @row_count.times.with_index do |y|
      @col_count.times.with_index do |x|
        next if @input[y][x] == '.'

        adjs = adj(y, x).map do |dir|
          pair = dir.find do |pair|
            prev[pair[0]][pair[1]] != '.'
          end

          prev[pair[0]][pair[1]] if pair
        end.compact

        count = adjs.count { |adj| adj == '#' }

        if count == 0
          @input[y][x] = '#'
        elsif count >= 5 && @input[y][x] == '#'
          @input[y][x] = 'L'
        end
      end
    end

    if prev.to_s == @input.to_s
      p @input.to_s.chars.count { |seat| seat == '#' }
    else
      run
    end
  end
end

input = File.open('input.txt').read.split("\n")
program = Program.new(input)

t = Time.now
program.run
p Time.now - t
