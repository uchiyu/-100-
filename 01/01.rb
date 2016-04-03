=begin
01. 「パタトクカシーー」
「パタトクカシーー」という文字列の1,3,5,7文字目を取り出して連結した文字列を得よ．
=end
s = "パタトクカシーー"
result = ''
s.size.times do |num|
  result << s[num] if num.odd?
end
puts result
