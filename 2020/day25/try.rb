# Alice and Bob establishing shared secret:
#
# shared secret
#  = (subject ** a_secret) ** b_secret   ==>   (subject ** a_secret) = a_public (mod n)
#  = (subject ** b_secret) ** a_secret   ==>   (subject ** b_secret) = b_public (mod n)
#
# In this problem, we are given the subject and both public keys.
# From them, we can calculate either one of the private keys.
# Once we have a private key, we can calculate the shared secret.

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
