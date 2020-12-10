require 'set'

#
# Part 1
#

# class Program
#   def initialize(input)
#     @input = input.map(&:to_i)
#
#     @ones = 0
#     @threes = 0
#   end
#
#   def run
#     nums = @input.map(&:to_i).sort
#     nums.each.with_index do |num, i|
#       if i == 0
#         prev = 0
#       else
#         prev = nums[i - 1]
#       end
#
#       if num - prev == 1
#         @ones += 1
#       elsif num - prev == 3
#         @threes += 1
#       else
#         raise '!'
#       end
#     end
#
#     p [@ones, @threes, @ones * (@threes + 1)]
#   end
# end
#
# input = File.open('input.txt').read.split("\n")
# program = Program.new(input)
# program.run

#
# Part 2
#

class Program
  def initialize(input)
    @input = input.map(&:to_i)

    @nums = @input.map(&:to_i).sort.unshift(0).reverse
    @cache = {}
  end

  def recurse(current)
    # Standard setup:
    return 1 if current == 0
    return @cache[current] if @cache[current]

    prevs = @nums.select { |num| num >= current - 3 && num < current }
    @cache[current] = prevs.map { |prev| recurse(prev) }.sum

    # Alternative setup:
    # prevs = @nums.select { |num| num >= current - 3 && num < current }
    # prevs.each { |prev| recurse(prev) unless @cache[prev] }
    #
    # return @cache[current] = 1 if current == 0
    # @cache[current] = prevs.map { |prev| @cache[prev] }.sum
  end

  def run
    p recurse(@nums.first)
  end
end

input = File.open('input.txt').read.split("\n")
program = Program.new(input)
program.run
