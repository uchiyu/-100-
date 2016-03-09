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
