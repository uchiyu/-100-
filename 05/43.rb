=begin
43. 名詞を含む文節が動詞を含む文節に係るものを抽出
名詞を含む文節が，動詞を含む文節に係るとき，これらをタブ区切り形式で抽出せよ．ただし，句読点などの記号は出力しないようにせよ．
=end

require 'cabocha'
require './Morph.rb'
require './Chunk.rb'

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
