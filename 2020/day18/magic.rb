class Integer
  # Part 1
  def -(other)
    self * other
  end

  # Part 2
  def **(other)
    self + other
  end
end

class Program
  def initialize(input)
    @input = input
  end

  def p1
    all = @input.map do |line|
      eval(line.gsub('*', '-'))
    end
    p all.sum
  end

  def p2
    all = @input.map do |line|
      eval(line.gsub('+', '**'))
    end
    p all.sum
  end
end

input = File.open('input.txt').read.split("\n")
program = Program.new(input)
program.p1
program.p2
