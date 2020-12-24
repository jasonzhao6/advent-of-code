# Still using a linked list conceptually, but with a few optimizations:
# 1. Link singly instead of doubly. Doubly is not necessary for this problem.
# 2. Link each number to its next number instead of object instance to its next object instance.
# 3. Store links in an array: array[current number] = next number.

class Program
  def initialize(input)
    @input = input

    @vals = input.split('').map(&:to_i)
    @nums = Array.new(@vals.size + 1) # Add 1 b/c input numbers start at 1.
    @vals.each_cons(2) { |cur, nex| @nums[cur] = nex }
    @nums[@vals.last] = @vals.first
    @cur = @vals.first
    @max = @vals.max
  end

  def round
    n1 = @nums[@cur]
    n2 = @nums[n1]
    n3 = @nums[n2]
    three = [n1, n2, n3]

    @nums[@cur] = @nums[n3]

    dest = @cur
    loop do
      dest -= 1
      dest = @max if dest == 0

      unless three.include?(dest)
        @nums[n3] = @nums[dest]
        @nums[dest] = n1

        @cur = @nums[@cur]
        break
      end
    end
  end

  def p1!
    100.times do |i|
      round
    end

    cur = 1
    cups = @vals.size.times.map do
      val = cur
      cur = @nums[cur]
      val
    end

    p cups.drop(1).join
  end

  def p2!
    # Insert more numbers up to 1 million.
    ((@max + 1)..1_000_000).each_cons(2) { |cur, nex| @nums[cur] = nex }
    @nums[@vals.last] = @max + 1
    @nums[1_000_000] = @vals.first
    @max = 1_000_000

    10_000_000.times do |i|
      p i if i % 1_000_000 == 0
      round
    end

    n1 = @nums[1]
    n2 = @nums[n1]
    p [n1, n2, n1 * n2]
  end
end

input = '389125467' # Sample
input = '193467258' # Actual
program = Program.new(input)
program.p1!
program = Program.new(input)
program.p2!
