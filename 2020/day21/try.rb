class Program
  def initialize(input)
    @input = input

    @all_igs = [] # All ingredients.
    @ag2igs = {} # Allergen to ingredients mapping.
  end

  def p1
    # Parse input.
    @input.each do |line|
      igs, ags = line.split(' (')

      igs = igs.split(' ')
      @all_igs.push(*igs)

      ags = ags.gsub('contains ', '').gsub(')', '').split(', ')
      ags.each do |ag|
        @ag2igs[ag] ||= igs
        @ag2igs[ag] = @ag2igs[ag] & igs
      end
    end

    # Reduce @ag2igs to all singles.
    @ag2igs.size.times do
      singles = @ag2igs.values.select { |igs| igs.size == 1 }.flatten
      @ag2igs.each do |ag, igs|
        next if igs.size == 1
        @ag2igs[ag] = igs - singles
      end
    end

    # Remove igs with ags from @all_igs.
    @ag2igs.each do |ag, igs|
      @all_igs.delete(igs[0])
    end

    # How many igs don't have ags?
    p @all_igs.size
  end

  def p2
    # Sort igs by their corresponding ags.
    p @ag2igs.sort.map(&:last).flatten.join(',')
  end
end

input = File.open('input.txt').read.split("\n")
program = Program.new(input)
program.p1
program.p2
