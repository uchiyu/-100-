=begin
05. n-gram
与えられたシーケンス（文字列やリストなど）からn-gramを作る関数を作成せよ．この関数を用い，"I am an NLPer"という文から単語bi-gram，文字bi-gramを得よ．
=end

def word_ngram(text, n, point)
  arr = text.split(' ')
  (point - (n - 1)..point + (n - 1)).each do |num|
    print arr[num], ' '
  end
  puts
end

def char_ngram(text, n, point)
  str = text.delete(' ')
  (point - (n - 1)..point + (n - 1)).each do |num|
    print str[num], ' '
  end
  puts
end

text = 'I am an NLPer'
word_ngram(text, 2, 2)
char_ngram(text, 2, 2)
