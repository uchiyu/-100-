def word_ngram(text, n, point)
  arr = text.split(' ')
  for num in point-(n-1)..point+(n-1)
    print arr[num], ' '
  end
  puts
end

def char_ngram(text, n, point)
  str = text.gsub(' ', '')
  for num in point-(n-1)..point+(n-1)
    print str[num], ' '
  end
  puts
end

text = 'I am an NLPer'
word_ngram(text, 2, 2)
char_ngram(text, 2, 2)


