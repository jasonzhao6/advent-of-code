#
# Part 1
#

# class Program
#   def initialize(input)
#     @nums = input[0].split(',').map(&:to_i)
#   end
#
#   def p1
#     (@nums.size...2020).each do
#       last = @nums.last
#       @nums << (is_new(last) ? 0 : get_gap(last))
#     end
#
#     p @nums.last
#   end
#
#   def get_gap(last)
#     seen = []
#     @nums.each.with_index do |num, i|
#       seen << i if num == last
#     end
#     min, max = seen.last(2)
#     max - min
#   end
#
#   def is_new(last)
#     @nums.count { |num| num == last } == 1
#   end
# end
#
# input = File.open('input.txt').read.split("\n")
# program = Program.new(input)
# program.p1

#
# Part 2
#

class Program
  def initialize(input)
    @nums = input[0].split(',').map(&:to_i)

    @last = @nums.last
    @dict = @nums.each.with_index.with_object({}) do |(num, i), hash|
      hash[num] = [i]
    end
  end

  def p2
    # target = 2020
    target = 30_000_000

    (@nums.size...target).each do |i|
      p i if i % 1_000_000 == 0

      insert(is_new(@last) ? 0 : get_gap(@last), i)
    end

    p @last
  end

  def insert(curr, i)
    @last = curr
    @dict[curr] ||= []
    @dict[curr] << i
    @dict[curr] = @dict[curr].last(2)
  end

  def get_gap(last)
    min, max = @dict[last]
    max - min
  end

  def is_new(last)
    @dict[last].size == 1
  end
end

input = File.open('input.txt').read.split("\n")
program = Program.new(input)
program.p2
