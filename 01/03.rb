=begin
03. 円周率
"Now I need a drink, alcoholic of course, after the heavy lectures involving quantum mechanics."という文を単語に分解し，
各単語の（アルファベットの）文字数を先頭から出現順に並べたリストを作成せよ．
=end

text = 'Now I need a drink, alcoholic of course, after the heavy lectures involving quantum mechanics.'

arr = text.split(' ')
word_num = {}

i = 0
arr.each do |word|
  word_num[i] = word.length
  i += 1
end

puts word_num[0]
