require 'set'

class Program
  attr_reader *%i[p1 p2]

  def initialize(in1, in2)
    @p1 = in1
    @p2 = in2

    @set = Set.new
  end

  def play
    loop do
      return :p1 if @set.include?(@p1)

      @set.add(@p1)

      c1 = @p1.shift
      c2 = @p2.shift

      if c1 <= @p1.size && c2 <= @p2.size
        sub = Program.new(@p1.first(c1), @p2.first(c2))
        if sub.play == :p1
          @p1.push(c1, c2)
        else
          @p2.push(c2, c1)
        end
      elsif c1 > c2
        @p1.push(c1, c2)
      else
        @p2.push(c2, c1)
      end

      return :p2 if @p1.empty?
      return :p1 if @p2.empty?
    end
  end
end

def parse(line)
  _label, nums = line.split(":\n")
  nums.split("\n").map(&:to_i)
end

input = File.open('input.txt').read.split("\n\n")
in1 = parse(input[0])
in2 = parse(input[1])

program = Program.new(in1, in2)
winner = program.play == :p1 ? program.p1 : program.p2
answer = winner.reverse.map.with_index do |card, i|
  card * (i + 1)
end.sum
p answer
