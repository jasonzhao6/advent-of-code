# Revised implementation for Part 2 using linked list.

class Num
  attr_accessor *%i[cur nex pre]

  def initialize(cur, nex, pre)
    @cur = cur
    @nex = nex
    @pre = pre
  end
end

class Program
  def initialize(input, size_override = nil)
    @input = input

    nums = input.split('').map(&:to_i)
    @size = size_override || nums.size
    @nums = Array.new(@size + 1) # Add 1 b/c input numbers start at 1.
    nums.each.with_index do |num, i|
      @nums[num] = Num.new(num, nums[(i + 1) % @size], nums[i - 1])
    end

    @cur = nums.first
    @max = nums.max
  end

  def nex(cur)
    @nums[cur].nex
  end

  def round
    n1 = nex(@cur)
    n2 = nex(n1)
    n3 = nex(n2)
    n4 = nex(n3)
    three = [n1, n2, n3]

    @nums[@cur].nex = n4
    @nums[n1].pre = nil
    @nums[n3].nex = nil
    @nums[n4].pre = @cur

    dest = @cur
    loop do
      dest -= 1
      dest = @max if dest == 0

      unless three.include?(dest)
        dest
        dest_nex = nex(dest)

        @nums[dest].nex = n1
        @nums[n1].pre = dest
        @nums[n3].nex = dest_nex
        @nums[dest_nex].pre = n3

        @cur = nex(@cur)
        break
      end
    end
  end

  def p1!
    100.times do |i|
      round
    end

    cur = @cur
    cups = @size.times.map do
      val = cur
      cur = nex(cur)
      val
    end

    p cups.rotate(cups.index(1)).drop(1).join
  end

  def p2!
    # Insert more numbers up to 1 million.
    ((@max + 1)..1_000_000).each do |num|
      @nums[num] = Num.new(num, num + 1, num - 1)
    end
    @nums[@nums[@cur].pre].nex = @max + 1
    @nums[@max + 1].pre = @nums[@cur].pre
    @nums[1_000_000].nex = @cur
    @nums[@cur].pre = 1_000_000
    @max = 1_000_000

    10_000_000.times do |i|
      p i if i % 1_000_000 == 0
      round
    end

    n1 = nex(1)
    n2 = nex(n1)
    p [n1, n2, n1 * n2]
  end
end

input = '389125467' # Sample
input = '193467258' # Actual
program = Program.new(input)
program.p1!
program = Program.new(input, 1_000_000)
program.p2!
