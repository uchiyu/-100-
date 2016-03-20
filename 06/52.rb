=begin
52. ステミング
51の出力を入力として受け取り，Porterのステミングアルゴリズムを適用し，単語と語幹をタブ区切り形式で出力せよ． Pythonでは，Porterのステミングアルゴリズムの実装としてstemmingモジュールを利用するとよい．
=end

require './50.rb'
require 'lingua/stemmer'

def split_word(sentence)
  words = sentence.split(' ')
  words = words.map {|word| word.delete('.').delete(':').delete(';').delete('!').delete('?').delete(',').delete('(').delete(')').delete('"')}
  return words
end

text = ''
File.open('nlp.txt', 'r').each_line do |line|
  text += line
end

sentences = split_sentence(text)

words_block = Array.new
sentences.each do |sentence|
  words_block.push(split_word(sentence))
end

words_block.each do |words|
  words.each do |word|
    next if word.strip == ''
    print word, "\t", Lingua.stemmer(word), "\n"
  end
end
