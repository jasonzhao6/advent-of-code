require 'set'

class Program
  attr_reader :accumulator

  def initialize(input)
    @input = input

    @pointer = 0
    @accumulator = 0
    @executed = Set.new
  end

  def step
    return :eof if @pointer == @input.size
    return :err if @executed.include?(@pointer)

    @executed << @pointer

    instruction = @input[@pointer]
    operation = instruction[0, 3]
    number = instruction[4..-1].to_i
    jump = 1

    case operation
    when 'nop'
    when 'acc' then @accumulator += number
    when 'jmp' then jump = number
    else raise '!'
    end

    @pointer += jump
    return :next
  end

  def run
    loop do
      result = step
      return result unless result == :next
    end
  end
end

# Part 1
input = File.open('input.txt').read.split("\n")
program = Program.new(input)
program.run
p program.accumulator

# Part 2
input.each.with_index do |instruction, index|
  operation = instruction[0, 3]
  next if operation == 'acc'

  input_copy = input.dup
  case operation
  when 'nop' then input_copy[index] = input_copy[index].gsub('nop', 'jmp')
  when 'jmp' then input_copy[index] = input_copy[index].gsub('jmp', 'nop')
  else raise '!'
  end

  program = Program.new(input_copy)
  result = program.run
  next if result == :err

  if result == :eof
    p program.accumulator
    return
  end
end
