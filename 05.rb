def word_bi_gram(text, point)
  arr = text.split(' ')
  print arr[point-1], ' ', arr[point], ' ', arr[point+1]
  puts
  
end

def char_bi_gram(text, point)
  str = text.gsub(' ', '')
  print str[point-1], ' ', str[point], ' ', str[point+1]
  puts
end

text = 'I am an NLPer'
word_bi_gram(text, 2)
char_bi_gram(text, 2)


