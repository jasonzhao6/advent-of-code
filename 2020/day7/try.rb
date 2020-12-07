require 'set'

class Foo
  def initialize(file)
    @file = file

    # Part 1
    @inverted = {}
    @outers = Set.new

    # Part 2
    @index = {}
    @inner_count = 0
  end

  def input()
    @input ||= File.open(@file).read.split("\n")
  end

  def parse_color(str)
    matches = str.match /(?<color>[a-z]+ [a-z]+) bag/
    matches[:color]
  end

  def parse_num(str)
    str.to_i
  end

  def look_out(bag)
    return if @inverted[bag].nil?
    @inverted[bag].each do |outer, _|
      @outers << outer
      look_out(outer)
    end
  end

  def part1
    input.each do |rule|
      outer, inner = rule.split(' contain ')
      inners = inner.split(', ')

      outer_name = parse_color(outer)
      inner_names = inners.map { |inner| parse_color(inner) }

      inner_names.each do |inner_name|
        @inverted[inner_name] ||= Set.new
        @inverted[inner_name] << outer_name
      end
    end

    look_out('shiny gold')
    p @outers.count
  end

  def look_in(bag)
    return if @index[bag].nil?
    @index[bag].each do |inner, count|
      @inner_count += count
      count.times { look_in(inner) }
    end
  end

  def part2
    input.each do |rule|
      outer, inner = rule.split(' contain ')
      inners = inner.split(', ')

      outer_name = parse_color(outer)

      inners.each do |inner|
        @index[outer_name] ||= {}
        @index[outer_name][parse_color(inner)] = parse_num(inner)
      end
    end

    look_in('shiny gold')
    p @inner_count
  end
end

foo = Foo.new('input.txt')
foo.part1
foo.part2
