text = 'Now I need a drink, alcoholic of course, after the heavy lectures involving quantum mechanics.'

arr = text.split(' ')
word_num = {}

i = 0
arr.each do |word|
  word_num[i] = word.length
  i = i + 1
end

puts word_num[0]
