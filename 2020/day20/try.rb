class Tile
  attr_reader *%i[id grid]

  def initialize(input)
    @input = input

    @id = @grid = nil
    parse_input
  end

  def top_edge
    grid.first
  end

  def right_edge
    grid.map { |row| row[-1] }.join
  end

  def bottom_edge
    grid.last
  end

  def left_edge
    grid.map { |row| row[0] }.join
  end

  def edges4
    [top_edge, right_edge, bottom_edge, left_edge]
  end

  def edges8
    edges4 + edges4.map(&:reverse)
  end

  def rotate_ccw
    @grid = @grid.size.times.map do |i|
      i = @grid.size - i - 1

      @grid.map { |line| line[i] }.join
    end
  end

  def flip_x
    @grid.reverse!
  end

  def flip_y
    @grid.each { |line| line.reverse! }
  end

  private

  def parse_input
    first, rest = @input.split("\n").partition.with_index { |line, i| i == 0 }

    @id = first[0].split(' ')[1].to_i # E.g. 'Tile 2311:'.
    @grid = rest
  end
end

class Monster
  def initialize
    @monster = [
      '..................#.',
      '#....##....##....###',
      '.#..#..#..#..#..#...',
    ]
  end

  def all8
    v1 = @monster.dup
    rotate_cw
    v2 = @monster.dup
    rotate_cw
    v3 = @monster.dup
    rotate_cw
    v4 = @monster.dup
    flip_x
    v5 = @monster.dup
    rotate_cw
    v6 = @monster.dup
    rotate_cw
    v7 = @monster.dup
    rotate_cw
    v8 = @monster.dup

    [v1, v2, v3, v4, v5, v6, v7, v8]
  end

  def size
    @monster.join.chars.count { |char| char == '#' }
  end

  private

  def rotate_cw
    y = @monster.size
    x = @monster[0].size

    @monster = x.times.map do |xi|
      y.times.map do |yi|
        yi = y - yi - 1
        @monster[yi][xi]
      end.join
    end
  end

  def flip_x
    @monster.reverse!
  end
end

class Program
  def initialize(input)
    @input = input

    @tiles = {}
    @nbors = {}
    @types = {}
    @grid = nil
    @image = []
  end

  def make_tiles
    @input.each do |block|
      tile = Tile.new(block)
      @tiles[tile.id] = tile
    end
  end

  NBORS_INDEX = {
    0 => :top,
    1 => :right,
    2 => :bottom,
    3 => :left,
  }

  def find_nbors
    @tiles.values.each do |tile|
      @nbors[tile.id] = {
        top: [],
        right: [],
        bottom: [],
        left: [],
      }

      tile.edges4.each.with_index do |edge, i|
        @tiles.each do |id, other|
          next if tile.id == id
          @nbors[tile.id][NBORS_INDEX[i]] << other.id if other.edges8.include?(edge)
        end
      end
    end
  end

  def find_types
    @nbors.each do |id, edges|
      sig = edges.map { |_edge, nbors| nbors.size }.sum

      @types[id] = :corner if sig == 2 # 0 0 1 1
      @types[id] = :edge if sig == 3   # 0 1 1 1
      @types[id] = :middle if sig == 4 # 1 1 1 1
    end
  end

  def grid_size
    Math.sqrt(@types.size).to_i
  end

  def rotate_helper(id)
    temp = @nbors[id][:top]
    @nbors[id][:top] = @nbors[id][:right]
    @nbors[id][:right] = @nbors[id][:bottom]
    @nbors[id][:bottom] = @nbors[id][:left]
    @nbors[id][:left] = temp

    @tiles[id].rotate_ccw
  end

  def rotate_cstone(id)
    4.times do
      break if @nbors[id][:right].size == 1 && @nbors[id][:bottom].size == 1
      rotate_helper(id)
    end
  end

  def rotate_nbors(source, dest, dir)
    4.times do
      break if @nbors[source][dir].first == dest
      rotate_helper(source)
    end
  end

  def make_grid
    @grid = Array.new(grid_size) { Array.new(grid_size) }

    grid_size.times do |y|
      grid_size.times do |x|
        # Lay the cornerstone.
        if y == 0 && x == 0
          @grid[y][x] = @types.find { |_id, type| type == :corner }[0]
          rotate_cstone(@grid[y][x])
          next
        end

        left = @grid.dig(y, x - 1)
        top = @grid.dig(y - 1, x)

        # Lay all the stones in a row based on the leftmost stone.
        if left
          lefts_right = @nbors[left][:right].first

          # Flip the leftmost stone if needed.
          if lefts_right.nil?
            lefts_right = @nbors[left][:left].first
            @tiles[left].flip_y
          end

          @grid[y][x] = lefts_right
          rotate_nbors(@grid[y][x], left, :left)

          # Flip self if needed.
          if @tiles[left].right_edge == @tiles[lefts_right].left_edge.reverse
            @tiles[lefts_right].flip_x
          end

          next
        # Lay the leftmost stone of each row.
        elsif top
          @grid[y][x] = @nbors[top][:bottom].first
          rotate_nbors(@grid[y][x], top, :top)
          next
        else
          raise '!'
        end
      end
    end
  end

  def make_image
    @grid.each do |row|
      tiles = row.map { |id| @tiles[id] }

      (1..8).each do |i|
        line = tiles.map do |tile|
          tile.grid[i][1...-1]
        end.join

        @image << line
      end
    end
  end

  def count_monsters
    count = 0

    monster = Monster.new
    monster.all8.each do |variation|
      y = variation.size
      x = variation[0].size
      x_cons = @image[0].size - x + 1

      @image.each_cons(y) do |ys|
        x_cons.times do |xi|
          viewport = ys.map { |yi| yi[xi, x] }

          count += 1 if viewport.join =~ /#{variation.join}/
        end
      end
    end

    count * monster.size
  end

  def p1
    make_tiles
    find_nbors
    find_types
    # print_types_and_nbors

    p @types.select { |_id, type| type == :corner }.map { |id, _type| id }.reduce(:*)
  end

  def print_types_and_nbors
    @types.each do |k, v|
      p [k, v.to_s.ljust(6), @nbors[k]]
    end
  end

  def p2
    make_grid
    # print_grid
    make_image

    p @image.join.chars.count { |char| char == '#' } - count_monsters
  end

  def print_grid
    @grid.each do |row|
      tiles = row.map { |id| @tiles[id] }

      10.times do |i|
        puts tiles.map { |tile| tile.grid[i] }.join(' ')
      end

      puts
    end
  end
end

input = File.open('input.txt').read.split("\n\n")
program = Program.new(input)
program.p1
program.p2
