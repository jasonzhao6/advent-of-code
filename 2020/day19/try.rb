class Program
  def initialize(input)
    @input = input

    @rules = {}
  end

  def store_rules(rules)
    rules.split("\n").each do |line|
      i, rule = line.split(': ')
      @rules[i] = rule
    end
  end

  def expand_rule(index)
    rule = @rules[index]

    @rules[index] = if false # Skip `if`, use only `elsif` to make reordering them easier.

    # Part 2
    elsif index == '8'
      "(#{expand_rule(rule)})+"
    elsif index == '11'
      expanded = (1..4).map do |i|
        rule.split(' ').map { |j| "(#{expand_rule(j)}){#{i}}" }.join
      end.join('|').prepend('(').concat(')')
    # Part 2 ^

    elsif rule =~ /^\d+( \d+)?$/
      rule.split(' ').map { |i| expand_rule(i) }.join
    elsif rule[0] == '"'
      rule[1]
    elsif rule !~ /\d/
      rule
    elsif rule.index('|')
      rule.split(' | ').map do |sub|
        sub.split(' ').map { |i| expand_rule(i) }.join
      end.join('|').prepend('(').concat(')')
    else
      puts rule
      raise '!'
    end
  end

  def run
    rules, lines = @input

    store_rules(rules)
    rule = expand_rule('0')
    rule = /^#{rule}$/

    count = 0
    lines.split("\n").each do |line|
      count += 1 if line =~ rule
    end
    p ['count', count]
  end
end

input = File.open('input.txt').read.split("\n\n")
program = Program.new(input)
program.run
