a = 5764801  # Sample
b = 17807724 # Sample

a = 12232269 # Real
b = 19452773 # Real

secret = 0
num = 1
loop do
  secret += 1
  num = num * 7 % 20201227

  if num == a
    p ['loop size:', secret]

    num = 1
    secret.times do
      num = num * b % 20201227
    end

    return p ['private key', num]
  end
end
