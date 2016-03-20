=begin
02. 「パトカー」＋「タクシー」＝「パタトクカシーー」
「パトカー」＋「タクシー」の文字を先頭から交互に連結して文字列「パタトクカシーー」を得よ．
=end

s1 = 'パトカー'
s2 = 'タクシー'
result = ''

for num in 0..s1.size-1 do
  result << s1[num] + s2[num]
end
puts result
