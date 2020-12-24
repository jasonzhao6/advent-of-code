# Initial implementation for Part 1 using array.
# This is too slow for Part 2 with 1MM numbers and 10MM rounds.

class Program
  def initialize(input)
    @input = input

    @nums = input.split('').map(&:to_i)
    @curr = @nums.first
    @max = @nums.max
  end

  def round
    index = @nums.index(@curr)
    three = @nums.slice!(index + 1, 3)

    next_num = @curr
    loop do
      next_num -= 1
      next_num = @max if next_num == 0

      next_index = @nums.index(next_num)
      if next_index
        @nums.insert(next_index + 1, *three)
        @curr = @nums[@nums.index(@curr) + 1]
        @nums.rotate!(@nums.index(@curr))
        break
      end
    end
  end

  def run
    100.times do |i|
       round
       p [i + 2, @curr, @nums]
    end

    i_of_1 = @nums.index(1)
    p @nums.rotate(i_of_1).drop(1).join
  end
end

input = '389125467' # sample
input = '193467258' # me
# input = '198753462' # tom
# input = '156794823' # sahil
program = Program.new(input)
program.run
