list = []

File.open('input.txt').each do |line|
  num = line.to_i
  list.each do |num2|
    list.each do |num3|
      return p num * num2 * num3 if (num + num2 + num3) == 2020
    end
  end
  list << num
end
