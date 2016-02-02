s1 = 'パトカー'
s2 = 'タクシー'
result = ''

for num in 0..s1.size-1 do
  result << s1[num] + s2[num]
end
puts result
