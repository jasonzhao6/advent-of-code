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

  def expand_rule(rule)
    if rule =~ /^\d+$/
      @rules[rule] = expand_rule(@rules[rule])

      # Part 2
      if rule == '8'
        @rules[rule] = "#{@rules['42']}+"
      elsif rule == '11'
        @rules[rule] = (1..4).map do |i|
          "#{@rules['42']}{#{i}}#{@rules['31']}{#{i}}"
        end.join('|').prepend('(').concat(')')
      end
      # Part 2 ^

      @rules[rule]
    elsif rule[0] == '"'
      rule[1]
    elsif rule !~ /\d/
      rule
    elsif rule =~ /^\d+( \d+)+$/
      rule.split(' ').map { |sub| expand_rule(sub) }.join
    elsif rule.index('|')
      rule.split(' | ').map { |sub| expand_rule(sub) }.join('|').prepend('(').concat(')')
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
