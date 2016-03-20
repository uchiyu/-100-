=begin
01. 「パタトクカシーー」
「パタトクカシーー」という文字列の1,3,5,7文字目を取り出して連結した文字列を得よ．
=end
s = "パタトクカシーー"
result = '';
for num in 0..s.size do
  if num%2 == 1 then
    result << s[num]
  end
end
puts result
