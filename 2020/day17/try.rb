#
# Part 1
#

# class Program
#   def initialize(input)
#     @input = input
#
#     # x, y, z
#     @toggle = true
#     @matrices = [{}, {}]
#     @xmin = @xmax = @ymin = @ymax = @zmin = @zmax = 0
#     init_input
#   end
#
#   def init_input
#     z = 0
#     @input.each.with_index do |line, y|
#       line.chars.each.with_index do |char, x|
#         mset(x, y, z, char)
#       end
#     end
#
#     @xmax = @input[0].size - 1
#     @ymax = @input.count - 1
#
#     toggle
#   end
#
#   def toggle
#     @toggle = !@toggle
#
#     @xmin -= 1
#     @xmax += 1
#     @ymin -= 1
#     @ymax += 1
#     @zmin -= 1
#     @zmax += 1
#   end
#
#   def mcurr
#     @toggle ? @matrices[0] : @matrices[1]
#   end
#
#   def mnext
#     @toggle ? @matrices[1] : @matrices[0]
#   end
#
#   def mget(x, y, z)
#     mcurr.dig(x, y, z)
#   end
#
#   def mset(x, y, z, char)
#     # p [x, y, z, char]
#     mnext[x] ||= {}
#     mnext[x][y] ||= {}
#     mnext[x][y][z] = char
#   end
#
#   def nei(x, y, z)
#     all = (x-1..x+1).map do |x_|
#       (y-1..y+1).map do |y_|
#         (z-1..z+1).map do |z_|
#           next if x == x_ && y == y_ && z == z_
#           mget(x_, y_, z_)
#         end
#       end
#     end.flatten
#     all = all.compact
#     all.count { |one| one == '#' }
#   end
#
#   def round
#     (@xmin..@xmax).each do |x_|
#       (@ymin..@ymax).each do |y_|
#         (@zmin..@zmax).each do |z_|
#           count = nei(x_, y_, z_)
#           if mget(x_, y_, z_) == '#'
#             if count == 2 || count == 3
#               mset(x_, y_, z_, '#')
#             else
#               mset(x_, y_, z_, '.')
#             end
#           else
#             if count == 3
#               mset(x_, y_, z_, '#')
#             else
#               mset(x_, y_, z_, '.')
#             end
#           end
#         end
#       end
#     end
#
#     toggle
#   end
#
#   def run
#     6.times do
#       round
#     end
#
#     print
#   end
#
#   def print
#     count = 0
#
#     (@xmin..@xmax).each do |x_|
#       (@ymin..@ymax).each do |y_|
#         (@zmin..@zmax).each do |z_|
#           if mget(x_, y_, z_) == '#'
#             # p [x_, y_, z_]
#             count += 1
#           end
#         end
#       end
#     end
#
#     p count
#   end
# end
#
# input = File.open('input.txt').read.split("\n")
# program = Program.new(input)
# program.run

#
# Part 2
#

class Program
  def initialize(input)
    @input = input

    # x, y, z, w
    @toggle = true
    @matrices = [{}, {}]
    @xmin = @xmax = @ymin = @ymax = @zmin = @zmax = @wmin = @wmax = 0
    init_input
  end

  def init_input
    z = 0
    w = 0
    @input.each.with_index do |line, y|
      line.chars.each.with_index do |char, x|
        mset(x, y, z, w, char == '#' ? 1 : 0)
      end
    end

    @xmax = @input[0].size - 1
    @ymax = @input.count - 1

    toggle
  end

  def toggle
    @toggle = !@toggle

    @xmin -= 1
    @xmax += 1
    @ymin -= 1
    @ymax += 1
    @zmin -= 1
    @zmax += 1
    @wmin -= 1
    @wmax += 1
  end

  def mcurr
    @toggle ? @matrices[0] : @matrices[1]
  end

  def mnext
    @toggle ? @matrices[1] : @matrices[0]
  end

  def mget(x, y, z, w)
    mcurr.dig(x, y, z, w)
  end

  def mset(x, y, z, w, char)
    # p [x, y, z, w, char]
    mnext[x] ||= {}
    mnext[x][y] ||= {}
    mnext[x][y][z] ||= {}
    mnext[x][y][z][w] = char
  end

  def nei(x, y, z, w)
    all = (x-1..x+1).map do |x_|
      (y-1..y+1).map do |y_|
        (z-1..z+1).map do |z_|
          (w-1..w+1).map do |w_|
            next if x == x_ && y == y_ && z == z_ && w == w_
            mget(x_, y_, z_, w_)
          end
        end
      end
    end.flatten
    all = all.compact
    all.sum
  end

  def round
    (@xmin..@xmax).each do |x_|
      (@ymin..@ymax).each do |y_|
        (@zmin..@zmax).each do |z_|
          (@wmin..@wmax).each do |w_|
            count = nei(x_, y_, z_, w_)
            if mget(x_, y_, z_, w_) == 1
              if count == 2 || count == 3
                mset(x_, y_, z_, w_, 1)
              else
                mset(x_, y_, z_, w_, 0)
              end
            else
              if count == 3
                mset(x_, y_, z_, w_, 1)
              else
                mset(x_, y_, z_, w_, 0)
              end
            end
          end
        end
      end
    end

    toggle
  end

  def run
    6.times do
      round
    end

    print
  end

  def print
    count = 0

    (@xmin..@xmax).each do |x_|
      (@ymin..@ymax).each do |y_|
        (@zmin..@zmax).each do |z_|
          (@wmin..@wmax).each do |w_|
            if mget(x_, y_, z_, w_) == 1
              # p [x_, y_, z_, w_]
              count += 1
            end
          end
        end
      end
    end

    p count
  end
end

input = File.open('input.txt').read.split("\n")
program = Program.new(input)
program.run
