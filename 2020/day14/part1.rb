class Program
  def initialize(input)
    @input = input

    @mem = {}
    @mask = {}
  end

  def run
    @input.each do |line|
      case line[0..2]
      when 'mas'
        do_mask(line)
      when 'mem'
        do_mem(line)
      else
        raise '!'
      end
    end

    p @mem.values.sum
  end

  def do_mask(line)
    _, mask = line.split(' = ')

    @mask = {}
    mask.chars.each.with_index do |char, i|
      @mask[i] = char if char != 'X'
    end
  end

  def do_mem(line)
    addr, num = line.split('] = ')
    addr = addr[4..-1].to_i
    num_bin = num.to_i.to_s(2).rjust(36, '0')

    # Apply the binary mask to the number.
    @mask.each do |k, v|
      num_bin[k] = v
    end

    # Store the masked number into memory.
    @mem[addr] = num_bin.to_i(2)
  end
end

input = File.open('input.txt').read.split("\n")
program = Program.new(input)
program.run
