require 'set'

#
# Part 1
#

# class Program
#   def initialize(input, preamble)
#     @input = input.map(&:to_i)
#     @preamble = preamble
#   end
#
#   def run
#     @input.each.with_index do |total, i|
#       next if i < @preamble
#
#       found = false
#
#       set = Set.new(@input[(i - @preamble)..(i - 1)])
#       set.each do |num|
#         found = true if set.include?(total - num)
#       end
#
#       return total unless found
#     end
#   end
# end
#
# input = File.open('input.txt').read.split("\n")
# program = Program.new(input, 25)
# p program.run

#
# Part 2
#

class Program
  def initialize(input, sum)
    @input = input.map(&:to_i)
    @sum = sum

    @ptr1 = 0
    @ptr2 = 1
  end

  def run
    loop do
      current_set = @input[@ptr1..@ptr2]
      current_sum = current_set.sum

      return current_set.min + current_set.max if current_sum == @sum

      if current_sum < @sum
        @ptr2 += 1
      else
        @ptr1 += 1
      end
    end
  end
end

input = File.open('input.txt').read.split("\n")
program = Program.new(input, 257342611)
p program.run
