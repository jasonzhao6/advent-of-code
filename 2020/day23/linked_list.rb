# Revised implementation for Part 2 using linked list.

class Num
  attr_accessor *%i[val nex pre]

  def initialize(val)
    @val = val
    @nex = nil
    @pre = nil
  end

  def link(nex)
    self.nex = nex
    nex.pre = self
  end

  def debug
    [val, nex&.val, pre&.val]
  end
end

class Program
  def initialize(input)
    @input = input

    vals = input.split('').map(&:to_i)
    @nums = Array.new(vals.size + 1) # Add 1 b/c input numbers start at 1.
    vals.each.with_index do |val, i|
      @nums[val] = Num.new(val)
      @nums[vals[i - 1]].link(@nums[val]) if @nums[vals[i - 1]]
    end
    @nums[vals.last].link(@nums[vals.first])
    @cur = @nums[vals.first]
    @max = @nums[vals.size]

    # @nums.each { |num| p num.debug if num }
  end

  def round
    n1 = @cur.nex
    n2 = n1.nex
    n3 = n2.nex
    three = [n1, n2, n3]

    @cur.link(n3.nex)

    dest = @cur
    loop do
      # @nums index 0 is nil and unused.
      dest = @nums[dest.val - 1] || @max

      unless three.include?(dest)
        n3.link(dest.nex)
        dest.link(n1)

        @cur = @cur.nex
        break
      end
    end
  end

  def p1!
    100.times do |i|
      round
    end

    cur = @cur
    cups = @input.size.times.map do
      val = cur.val
      cur = cur.nex
      val
    end

    p cups.rotate(cups.index(1)).drop(1).join
  end

  def p2!
    # Insert more numbers up to 1 million.
    ((@max.val + 1)..1_000_000).each do |val|
      @nums[val] = Num.new(val)
      @nums[val - 1].link(@nums[val]) if val > @max.val + 1
    end
    @cur.pre.link(@nums[@max.val + 1])
    @max = @nums[1_000_000]
    @max.link(@cur)

    10_000_000.times do |i|
      p i if i % 1_000_000 == 0
      round
    end

    n1 = @nums[1].nex
    n2 = n1.nex
    p [n1.val, n2.val, n1.val * n2.val]
  end
end

input = '389125467' # Sample
input = '193467258' # Actual
program = Program.new(input)
program.p1!
program = Program.new(input)
program.p2!
