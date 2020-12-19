class Program
  def initialize(input)
    @input = input

    @rules = []
  end

  def store_rules(rules)
    rules.split("\n").each do |line|
      i, rule = line.split(': ')
      @rules[i.to_i] = rule
    end
  end

  def expand_rule(i)
    return i if i == '|'

    i = i.to_i
    return @rules[i][1] if @rules[i][0] == '"'
    return @rules[i] unless @rules[i][0] =~ /\d/

    @rules[i] = @rules[i].split(' ').map do |j|
      expand_rule(j)
    end.join
    @rules[i] = "(#{@rules[i]})"

    # Part 2
    @rules[i] = "#{@rules[42]}+" if i == 8
    if i == 11
      @rules[i] = (1..4).map { |j| "(#{@rules[42]}{#{j}}#{@rules[31]}{#{j}})" }.join('|')
      @rules[i] = "(#{@rules[i]})"
    end

    @rules[i]
  end

  def run
    store_rules(@input[0])
    rule = expand_rule('0')
    rule = /^#{rule}$/

    count = 0
    @input[1].split("\n").each do |line|
      count += 1 if line =~ rule
    end
    p ['count', count]
  end
end

input = File.open('input.txt').read.split("\n\n")
program = Program.new(input)
program.run
