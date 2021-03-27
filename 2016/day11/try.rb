require 'set'

class Program
  def initialize(input)
    @input = input
    @start = parse_input(@input)
  end

  def p1
    bfs = [@start]
    queued = Set.new.add(@start.reduce)

    loop_count = 0
    max_step = 0
    loop do
      loop_count += 1
      state = bfs.shift

      # Print progress and final answer.
      # p [max_step = state.steps, loop_count] if state.steps > max_step
      return p 'impossible' if state.nil?
      return p [state.steps, loop_count] if state.done?

      # Add future choices to queue if they haven't been queued before.
      # Note: Deduping at queuing time keeps BFS queue smaller than at visit time.
      state.choices.each do |choice|
        bfs.push(choice) if queued.add?(choice.reduce)
      end
    end
  end

  def p2
    max = @start.levels[0].max

    2.times.each do |i|
      element = max + i + 1
      @start.levels[0].push(-element, element)
    end

    p1
  end

  private

  def parse_input(input)
    # Collect elements in this array, so to convert them into corresponding indices.
    # Index 0 is blocked off. Treat generators as negatives and microchips as positives.
    elements = ['noop']

    state = input.map do |line|
      line.gsub('and', ',').gsub('.', '').split(',').map do |item|
        tokens = item.gsub('-compatible', '').split(' ')

        if ['generator', 'microchip'].include?(tokens.last)
          element, type = tokens.last(2)
          index = elements.index(element)

          if index.nil?
            elements.push(element)
            index = elements.size - 1
          end

          case type
          when 'generator' then -index
          when 'microchip' then index
          else raise '!'
          end
        end
      end.compact
    end

    State.new(state)
  end
end

class State
  MIN = 0
  MAX = 3

  attr_reader :levels, :elevator, :steps

  def initialize(levels, elevator = 0, steps = 0)
    @levels = levels
    @elevator = elevator
    @steps = steps
  end

  def choices
    c1s = @levels[@elevator].combination(1)
    c2s = @levels[@elevator].combination(2).select { |pairs| valid?(pairs) }

    [
      c1s.map { |c| go_up(c) },
      c1s.map { |c| go_down(c) },
      c2s.map { |c| go_up(c) }
    ].flatten(1).compact
  end

  def done?
    @levels[0].size == 0 &&
      @levels[1].size == 0 &&
      @levels[2].size == 0
  end

  # Reduce each element pair to their level positions: [level of generator, level of microchip].
  # Given 2 different element pairs with the same level positions, e.g Ax;Axxx == xB;xBxx,
  # They are interchangeable in terms of shortest path left to the goal.
  def reduce
    elements = @levels.flatten.select(&:positive?)
    elements.map do |element|
      [
        @levels.index { |level| level.include?(-element) },
        @levels.index { |level| level.include?(element) }
      ]
    end.sort.unshift(@elevator)
  end

  private

  def valid?(level)
    level.none? do |element|
      # 'If a chip is ever left in the same area as another RTG,
      # and it's not connected to its own RTG, the chip will be fried.'
      element.positive? && level.any?(&:negative?) && !level.include?(-element)
    end
  end

  def go_up(combo)
    return if @elevator == MAX
    return unless valid?(@levels[@elevator + 1] + combo)
    return unless valid?(@levels[@elevator] - combo)

    state = @levels.map.with_index do |level, index|
      if index == @elevator
        level - combo
      elsif index == @elevator + 1
        level + combo
      else
        level
      end
    end

    State.new(state, @elevator + 1, @steps + 1)
  end

  def go_down(combo)
    return if @elevator == MIN
    return if (MIN...@elevator).all? { |index| @levels[index].size == 0 }
    return unless valid?(@levels[@elevator - 1] + combo)
    return unless valid?(@levels[@elevator] - combo)

    state = @levels.map.with_index do |level, index|
      if index == @elevator
        level - combo
      elsif index == @elevator - 1
        level + combo
      else
        level
      end
    end

    State.new(state, @elevator - 1, @steps + 1)
  end
end

input = File.open('input.txt').read.split("\n")
program = Program.new(input)
program.p1
program.p2
