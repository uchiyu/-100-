# -*- coding: utf-8 -*-
require 'natto'

def read_mecab(file_name)
  mecab_data = Array.new
  data = Array.new
  open(file_name).each do |line|
    if line =~ /EOS/
      mecab_data.push(data)
      data = Array.new
      next
    end
    line_data = line.chomp.split(/\t/)
    surface = line_data[0]
    block = line_data[1].split(',')
    data.push({:surface=>surface, :base=>block[6], :pos=>block[0], :pos1=>block[1]})
  end
  return mecab_data
end

name = 'neko.txt.mecab'
mecab_data = read_mecab(name)

sequence_noun = Array.new
max_sequence_noun = Array.new
mecab_data.each do | block_data |
  sequence_noun = Array.new
  block_data.each do | word |
    # 名詞なら名詞連の更新
    if word[:pos] == '名詞'
      sequence_noun.push(word[:surface])
    # 名詞以外なら更新処理のあと、名詞連の初期化
    else
      if max_sequence_noun.length < sequence_noun.length
        max_sequence_noun = sequence_noun
      end
      sequence_noun = Array.new
    end
    # 名詞で終了した場合も考えて名詞連の更新処理
    if max_sequence_noun.length < sequence_noun.length
      max_sequence_noun = sequence_noun
    end
  end
end

print max_sequence_noun
