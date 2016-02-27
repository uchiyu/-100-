# coding: utf-8

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
