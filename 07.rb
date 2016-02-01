def text_generate(x, y, z)
  str = x.to_s + '時の' + y.to_s + 'は' + z.to_s
  return str
end

x = 12
y = '気温'
z = 22.4

puts text_generate(x, y, z)
