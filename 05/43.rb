# coding: utf-8

require 'cabocha'

class Morph
  def initialize(mecab_line_data)
    line_data = mecab_line_data.split(/\t/)
    return if line_data[0] =~ /EOS/
    @surface = line_data[0]
    mecab_data_split(line_data[1])
  end

  def mecab_data_split(mecab_data)
    block = mecab_data.to_s.split(',')
    @base = block[6];
    @pos = block[0];
    @pos1 = block[1];
  end
  attr_accessor :surface, :base, :pos, :pos1
end

# 一ブロックと一文節のCaboChaデータを引数に
class Chunk
  def initialize(cabocha_data_block, cabocha_data)
    set_cabocha_data(cabocha_data_block, cabocha_data)
  end

  def set_cabocha_data(cabocha_data_block, cabocha_data)
    morphs = Array.new
    cabocha_data_block.each_line do |line_data|
      cabocha_inf = line_data.split(/ /)
      if cabocha_inf[0] == '*'
        @dst = cabocha_inf[2]

        # srcsリストの作成
        srcs_list = Array.new
        cabocha_data.each_line do |tmp|
          data = tmp.split(/ /)
          if cabocha_inf[1].to_s == data[2].to_s.delete('D')
            srcs_list.push(data[1])
          end
          @srcs = srcs_list
        end
      else
        morphs.push(Morph.new(line_data))
      end
      # morphsを追加
      @morphs = morphs
    end
  end
  attr_accessor :morphs, :dst, :srcs
end

# 修飾された語を返す
# 返却値に動詞を含んでいるかのフラグを含む
def modifier_to_word(dst, chunks)
  have_verb = false
  modified_word = ''
  return modified_word if dst == -1
  chunks[dst].morphs.each do |morph|
    pos =morph.pos.to_s.force_encoding("UTF-8")
    have_verb = true if pos  =~ /動詞/
    modified_word += morph.surface.to_s unless pos  =~ /記号/
  end
  return modified_word, have_verb
end

parser = CaboCha::Parser.new
chunks_lists = Array.new()
text = ''
open('neko.txt.cabocha', 'r').each do |word|
  word = word.gsub(/-*?D/, '').gsub('|', '').strip
  next if word =~ /EOS/
  text += word.to_s

  # 一文の区切り
  chunks = Array.new
  if word =~ /。/
    # 文節ごとに分けて各chunkを生成
    tree = parser.parse(text)
    cabocha_sentence_data = tree.toString(CaboCha::FORMAT_LATTICE)
    block = ''
    cabocha_sentence_data.each_line do |line_data|
      cabocha_inf = line_data.split(/ /)
      if cabocha_inf[0] == '*' && block != ''
        chunks.push(Chunk.new(block, cabocha_sentence_data))
        block = ''
      end
      block += line_data
    end
    # 文末の追加
    chunks.push(Chunk.new(block, cabocha_sentence_data))

    chunks_lists.push(chunks)

    chunks = Array.new
    #chunks.clear # 何故かclearで初期化するとchunks_listsに一つしか入らない
    text = ''
  end
end

have_noun = false
have_verb = false
chunks_lists.each do |chunks|
  chunks.each do |chunk|
    tmp = modifier_to_word(chunk.dst.to_s.delete('D').to_i, chunks)
    modified_word = tmp[0]
    have_verb = tmp[1]
    next if modified_word == ''
    
    # 出力処理
    surface = ''
    chunk.morphs.each do |morph|
      have_noun = true if morph.pos.to_s.strip == '名詞'
      surface += morph.surface.to_s unless morph.pos.to_s.strip == '記号'
    end

    # フラグが立っていれば出力
    if have_noun && have_verb
      print surface, "\t", modified_word , "\n"
    end
    have_noun = false
    have_verb = false
  end
end
