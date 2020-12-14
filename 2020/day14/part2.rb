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
      @mask[i] = char if char != '0'
    end
  end

  def do_mem(line)
    addr, num = line.split('] = ')
    addr_bin = addr[4..-1].to_i.to_s(2).rjust(36, '0')

    # Apply the binary mask to the address.
    @mask.each do |k, v|
      addr_bin[k] = v
    end

    # Expand each instance of 'X' into its 2 possibilities: 1 vs 0.
    # When there is no 'X' left, convert that permutation back to integer.
    addr_ints = []
    addr_bins = [addr_bin]
    until addr_bins.empty? do
      curr = addr_bins.pop
      i = curr.index('X')

      # No more 'X'.
      if i.nil?
        addr_ints << curr.to_i(2)
        next
      end

      # Expand 'X'.
      a = curr.dup
      a[i] = '0'
      b = curr.dup
      b[i] = '1'
      addr_bins.push(a, b)
    end

    addr_ints.each do |addr|
      @mem[addr] = num.to_i
    end
  end
end

input = File.open('input.txt').read.split("\n")
program = Program.new(input)
program.run
