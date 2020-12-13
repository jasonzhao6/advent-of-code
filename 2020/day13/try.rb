class Program
  def initialize(input)
    @min = input[0].to_i
    @ids = input[1].split(',').map { |id| id == 'x' ? 'x' : id.to_i }
  end

  def p1
    ts = @min * 2
    bus = nil

    # 939 % 7 = 1 (A multiple of 7 is 1 short of 939.)
    # 939 % 13 = 3 (A multiple of 13 is 3 short of 939.)
    # ...
    ids = @ids.select { |id| id != 'x' }
    ids.each do |id|
      diff = @min % id
      new_ts = @min - diff + id

      if new_ts < ts
        ts = new_ts
        bus = id
      end
    end

    p bus * (ts - @min)
  end

  def p2
    ids_and_offsets = @ids.map.with_index { |id, i| [id.to_i, i] if id != 'x' }.compact

    # Start with a timestamp that works for the first bus.
    # Need to ensure that the increment is always a mulitple of the first bus.
    ts = inc = ids_and_offsets[0][0]

    # For each of the other buses, find the next working timestamp, then update increment like so:
    # E.g. Given (3, 7), these timestamps work: [6, 27, 48, 69]. Notice how they increment by 3 * 7.
    ids_and_offsets[1..-1].each do |id, offset|
      ts += inc until (ts + offset) % id == 0
      inc *= id
    end

    p ts
  end
end

input = File.open('input.txt').read.split("\n")
program = Program.new(input)
program.p1
program.p2
