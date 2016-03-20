=begin
40. 係り受け解析結果の読み込み（形態素）
形態素を表すクラスMorphを実装せよ．このクラスは表層形（surface），基本形（base），品詞（pos），品詞細分類1（pos1）をメンバ変数に持つこととする．さらに，CaboChaの解析結果（neko.txt.cabocha）を読み込み，各文をMorphオブジェクトのリストとして表現し，3文目の形態素列を表示せよ．
=end

require 'natto'

class Morph
  def initialize(mecab_line_data)
    line_data = mecab_line_data.split(/\t/)
    return if line_data[0] =~ /EOS/
    @surface = line_data[0]
    mecab_data_split(line_data[1])
  end

  def mecab_data_split(mecab_data)
    block = mecab_data.split(',')
    @base = block[6];
    @pos = block[0];
    @pos1 = block[1];
  end
  attr_accessor :surface, :base, :pos, :pos1
end

morphs = Array.new
sentence = Array.new
natto = Natto::MeCab.new
open('neko.txt.cabocha', 'r').each do |word|
  word = word.gsub(/-*?D/, '').gsub('|', '').strip

  natto.parse(word) do |line|
    # EOSは無視
    next if line.feature =~ /EOS/

    text = line.surface + "\t" + line.feature
    # Morph型をlistに格納
    sentence.push(Morph.new(text))
    if line.surface =~ /。/
      morphs.push(sentence)
      sentence = Array.new
    end
  end
end

morphs[2].each do |word|
  print word.surface
end
