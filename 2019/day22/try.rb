class Program
  attr_reader :a, :b

  def initialize(input, size)
    @input = input
    @size = size

    @a = 1
    @b = 0
  end

  def f(x)
    (@a * x + @b) % @size
  end

  #
  # Part 1
  #

  def forward
    @input.each do |line|
      cmd, num = parse(line)

      case cmd
      when :rev
        # rev _ = a'(ax + b) + b'
        #       = -1(ax + b) - 1
        #       =   -ax - b - 1
        @a = -@a
        @b = -@b - 1
      when :cut
        # cut n = a'(ax + b) + b'
        #       =  1(ax + b) + (size - n)
        #       =    ax + b - n
        @b = @b - num
      when :inc
        # inc n = a'(ax + b) + b'
        #       =  n(ax + b) + 0
        #       =   nax + bn
        @a = @a * num
        @b = @b * num
      else
        raise '!'
      end
    end
  end

  #
  # Part 2
  #

  def backward
    @input.reverse.each do |line|
      cmd, num = parse(line)

      case cmd
      when :rev
        # Same as forward.
        @a = -@a
        @b = -@b - 1
      when :cut
        # Opposite of forward.
        @b = @b + num
      when :inc
        # Opposite of forward, but using modular arithmetics for division.
        inv = mod_mul_inv(num)
        @a = @a * inv
        @b = @b * inv
      else
        raise '!'
      end
    end
  end

  def backward_n(times, x)
    backward # To set @a and @b.
    geo_series(times - 1, x)
  end

  private

  def parse(line)
    num = line.split(' ').last.to_i

    if line[0, 9] == 'deal into'
      [:rev]
    elsif line[0, 3] == 'cut'
      [:cut, num]
    elsif line[0, 9] == 'deal with'
      [:inc, num]
    else
      raise '!'
    end
  end

  # Not sure how to derive this.
  def mod_mul_inv(num)
    mod_exp(num, @size - 2)
  end

  # E.g. 3 ^ 4 == (3 * 3) ^ (4 / 2)
  def mod_exp(base, exp)
    if exp == 0
      1
    elsif exp.even?
      mod_exp(base * base % @size, exp / 2)
    else
      mod_exp(base, exp - 1) * base % @size
    end
  end

  # Step 1: Spot the geometric series.
  # f(x)                                     = ax +                            b
  # f^2(x) = a(ax + b) + b                   = a^2(x) +                   ab + b
  # f^3(x) = a(a^2(x) + ab + b) + b          = a^3(x) +          a^2(b) + ab + b
  # f^4(x) = a(a^3(x) + a^2(b) + ab + b) + b = a^4(x) + a^3(b) + a^2(b) + ab + b
  #                                            --#1-- + -----------#2-----------
  #                                                     => sum a^n * b, n=0 to infinity
  # Step 2: Get the partial sum formula.
  # https://www.wolframalpha.com/input/?i=sum+a%5En+*+b%2C+n%3D0+to+infinity
  #
  # Step 3: Use modular arithmetics for exponentiation and division.
  def geo_series(times, x)
    (
      mod_exp(@a, times) * f(x) +                         #1
      (mod_exp(@a, times) - 1) * @b * mod_mul_inv(@a - 1) #2
    ) % @size
  end
end

input = File.open('input.txt').read.split("\n")

# Part 1, what is the current position of card 2019?
size = 10007
program = Program.new(input, size)
program.forward
p program.f(2019)

# Part 2, which card is currently at position 2020?
size = 119_315_717_514_047
program = Program.new(input, size)
p program.backward_n(101_741_582_076_661, 2020)
