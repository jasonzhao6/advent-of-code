require 'set'

#
# Part 1
#

#  N
# W E
#  S

class Program
  def initialize(input)
    @input = input

    @dir = %w[E S W N] # Clockwise
    @ew = 0
    @ns = 0
  end

  def nsew(cmd, num)
    case cmd
    when 'N'
      @ns += num
    when 'S'
      @ns -= num
    when 'E'
      @ew += num
    when 'W'
      @ew -= num
    else
      raise '!!'
    end
  end

  def run
    @input.each do |line|
      cmd = line[0]
      num = line[1..-1].to_i

      case cmd
      when *@dir
        nsew(cmd, num)
      when 'L'
        mul = num / 90
        @dir.rotate!(-mul)
      when 'R'
        mul = num / 90
        @dir.rotate!(mul)
      when 'F'
        nsew(@dir[0], num)
      else
        raise '!'
      end
    end
      p [@ew.abs + @ns.abs, '', @ew, @ns]
  end
end

input = File.open('input.txt').read.split("\n")
program = Program.new(input)

t = Time.now
program.run
p Time.now - t

#
# Part 2
#

#  N
# W E
#  S

class Program
  def initialize(input)
    @input = input

    # Ship
    @ew0 = 0
    @ns0 = 0

    # Waypoint
    @ew1 = 10
    @ns1 = 1
  end

  def run
    @input.each do |line|
      cmd = line[0]
      num = line[1..-1].to_i

      case cmd
      when 'N'
        @ns1 += num
      when 'S'
        @ns1 -= num
      when 'E'
        @ew1 += num
      when 'W'
        @ew1 -= num
      when 'L'
        # E.g. L90: [10 E, 4 N] => [10 N, 4 W]
        mul = num / 90
        mul.times do
          ns1 = @ns1
          @ns1 = @ew1
          @ew1 = -ns1
        end
      when 'R'
        # E.g. R90: [10 E, 4 N] => [10 S, 4 E]
        mul = num / 90
        mul.times do
          ns1 = @ns1
          @ns1 = -@ew1
          @ew1 = ns1
        end
      when 'F'
        @ew0 += @ew1 * num
        @ns0 += @ns1 * num
      else
        raise '!'
      end
    end
      p [@ew0.abs + @ns0.abs, '', @ew0, @ns0]
  end
end

input = File.open('input.txt').read.split("\n")
program = Program.new(input)

t = Time.now
program.run
p Time.now - t
