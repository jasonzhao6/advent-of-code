input = 'L1, L5, R1, R3, L4, L5, R5, R1, L2, L2, L3, R4, L2, R3, R1, L2, R5, R3, L4, R4, L3, R3, R3, L2, R1, L3, R2, L1, R4, L2, R4, L4, R5, L3, R1, R1, L1, L3, L2, R1, R3, R2, L1, R4, L4, R2, L189, L4, R5, R3, L1, R47, R4, R1, R3, L3, L3, L2, R70, L1, R4, R185, R5, L4, L5, R4, L1, L4, R5, L3, R2, R3, L5, L3, R5, L1, R5, L4, R1, R2, L2, L5, L2, R4, L3, R5, R1, L5, L4, L3, R4, L3, L4, L1, L5, L5, R5, L5, L2, L1, L2, L4, L1, L2, R3, R1, R1, L2, L5, R2, L3, L5, L4, L2, L1, L2, R3, L1, L4, R3, R3, L2, R5, L1, L3, L3, L3, L5, R5, R1, R2, L3, L2, R4, R1, R1, R3, R4, R3, L3, R3, L5, R2, L2, R4, R5, L4, L3, L1, L5, L1, R1, R2, L1, R3, R4, R5, R2, R3, L2, L1, L5'

# Tom's solution.
input.gsub!(/R/, '; b *= -1i; p += b * ')
input.gsub!(/L/, '; b *= 1i; p += b * ')
input.gsub!(/, /, '')
p eval("p = 0; b = 1i#{input}; p.real.abs + p.imag.abs")

# Code golfed solution.
p eval"p=0;b=1#{input.gsub(/R|L/){|x|";b*=#{x==?R?-1:1}i;p+=b*"}.tr',',''};p.rect.sum(&:abs)"

# Mapping [R, L] to [1, -1] can be obfuscated as `(x.ord-79)/3`.
