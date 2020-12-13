require 'openssl'

instructions = []
File.readlines('input.txt').each do |line|
  instructions << line.chomp
end

class ShuffleTracker
  def initialize(size)
    @size      = size
    @offset    = 0
    @increment = 1
  end

  def deal(increment)
    @increment = @increment * mod_inv(increment) % @size
  end

  def cut(position)
    @offset = (@offset + @increment * position) % @size
  end

  def reverse
    @offset = (@offset - @increment) % @size
    @increment = -@increment % @size
  end

  def repeat(iterations)
    @offset    = @offset * ((1 - mod_exp(@increment, iterations)) * (mod_inv(1 - @increment))) % @size
    @increment = mod_exp(@increment, iterations)
  end

  def card_at(position)
    (@offset + position * @increment) % @size
  end

  private

  def mod_exp(a, b)
    a.to_bn.mod_exp(b, @size).to_i
  end

  def mod_inv(a)
    mod_exp(a, @size - 2)
  end
end

DECK_SIZE  = 119315717514047
ITERATIONS = 101741582076661

deck = ShuffleTracker.new(DECK_SIZE)

instructions.each do |inst|
  case inst
  when /deal with increment (-?\d+)/
    deck.deal($1.to_i)
  when /cut (-?\d+)/
    deck.cut($1.to_i)
  when 'deal into new stack'
    deck.reverse
  else
    raise 'WTF'
  end
end

deck.repeat(ITERATIONS)

puts deck.card_at(2020)
