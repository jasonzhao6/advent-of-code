class Program
  def initialize(input)
    @input = input

    @rules = {}
    @tickets = []
    @maybes = {}
  end

  def parse_input
    @input.each do |line|
      if line.index(' or ')
        parse_rule(line)
      elsif line.index(',')
        parse_ticket(line)
      end
    end
  end

  def parse_rule(rule)
    m = rule.match /([a-z ]+): (\d+)-(\d+) or (\d+)-(\d+)/

    @rules[m[1]] = {
      min1: m[2].to_i,
      max1: m[3].to_i,
      min2: m[4].to_i,
      max2: m[5].to_i,
    }

    @maybes[m[1]] = []
  end

  def parse_ticket(ticket)
    @tickets << ticket.split(',').map(&:to_i)
  end

  #
  # Part1
  #

  def p1
    # Get the sum of invalid numbers.
    invalids = @tickets.flatten.select { |num| !valid?(num) }
    p invalids.sum
  end

  def valid?(num)
    @rules.any? do |name, range|
      (num >= range[:min1] && num <= range[:max1]) ||
        (num >= range[:min2] && num <= range[:max2])
    end
  end

  #
  # Part 2
  #

  def p2
    remove_invalids
    collect_all_maybes
    deduct_to_1_maybe

    # Get the product of all departure numbers.
    positions = @maybes.select { |name, _| name.start_with?('departure') }.values.flatten
    p positions.map { |i| @tickets[0][i] }.reduce(:*)
  end

  def remove_invalids
    @tickets.select! do |ticket|
      ticket.all? { |num| valid?(num) }
    end
  end

  def collect_all_maybes
    positions = @tickets[0].size
    @maybes.each do |name, maybes|
      positions.times do |i|
        maybes << i if @tickets.all? { |ticket| valid_for?(name, ticket[i]) }
      end
    end
  end

  def deduct_to_1_maybe
    positions = @tickets[0].size
    positions.times do
      singles = @maybes.values.select { |maybes| maybes.size == 1 }.flatten
      @maybes.each do |name, maybes|
        next if maybes.size == 1
        @maybes[name] = maybes - singles
      end
    end
  end

  def valid_for?(name, num)
    range = @rules[name]
    (num >= range[:min1] && num <= range[:max1]) ||
      (num >= range[:min2] && num <= range[:max2])
  end
end

input = File.open('input.txt').read.split("\n")
program = Program.new(input)
program.parse_input
program.p1
program.p2
