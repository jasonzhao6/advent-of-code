class Program
  def initialize(input)
    @input = input
  end

  def calc(line)
    tokens = line.split(' ')
    val = tokens.shift.to_i

    tokens.each_slice(2) do |op, num|
      case op
        when '+' then val += num.to_i
        when '*' then val *= num.to_i
        else raise '!'
      end
    end

    val.to_s
  end

  def expand_paren!(line, plus_1st: false)
    return line unless line.index('(')

    m = line.match(/\(\d+( [+*] \d+)+\)/)
    i = line.index(m[0])
    subline = m[0][1...-1]
    subline = expand_plus!(subline) if plus_1st
    line[i, m[0].size] = calc(subline)
    expand_paren!(line, plus_1st: plus_1st)
  end

  def expand_plus!(line)
    return line unless line.index('+')

    m = line.match(/\d+( \+ \d+)+/)
    i = line.index(m[0])
    line[i, m[0].size] = calc(m[0])
    expand_plus!(line)
  end

  def p1
    all = @input.map do |line|
      line = line.dup
      line = expand_paren!(line)
      calc(line).to_i
    end
    p all.sum
  end

  def p2
    all = @input.map do |line|
      line = line.dup
      line = expand_paren!(line, plus_1st: true)
      line = expand_plus!(line)
      calc(line).to_i
    end
    p all.sum
  end
end

input = File.open('input.txt').read.split("\n")
program = Program.new(input)
program.p1
program.p2
