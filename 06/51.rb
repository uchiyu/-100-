=begin
51. 単語の切り出し
空白を単語の区切りとみなし，50の出力を入力として受け取り，1行1単語の形式で出力せよ．ただし，文の終端では空行を出力せよ．
=end

require './50.rb'

def split_word(sentence)
  words = sentence.split(' ')
  words.push("\n")
  return words
end

text = ''
File.open('nlp.txt', 'r').each_line do |line|
  text += line
end

sentences = split_sentence(text)

words = Array.new
sentences.each do |sentence|
  words.push(split_word(sentence))
end

words.each do |word|
  puts word
end
