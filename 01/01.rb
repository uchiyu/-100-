s = "パタトクカシーー"
result = '';
for num in 0..s.size do
  if num%2 == 1 then
    result << s[num]
  end
end
puts result
