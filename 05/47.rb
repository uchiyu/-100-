=begin
動詞のヲ格にサ変接続名詞が入っている場合のみに着目したい．46のプログラムを以下の仕様を満たすように改変せよ．

「サ変接続名詞+を（助詞）」で構成される文節が動詞に係る場合のみを対象とする
述語は「サ変接続名詞+を+動詞の基本形」とし，文節中に複数の動詞があるときは，最左の動詞を用いる
述語に係る助詞（文節）が複数あるときは，すべての助詞をスペース区切りで辞書順に並べる
述語に係る文節が複数ある場合は，すべての項をスペース区切りで並べる（助詞の並び順と揃えよ）
=end

require 'cabocha'
require './Morph.rb'
require './Chunk.rb'

# 修飾された語を返す
# 返却値に動詞を含んでいるかのフラグを含む
def modifier_to_word(dst, chunks)
  modified_word = ''
  return modified_word if dst == -1
  chunks[dst].morphs.each do |morph|
    pos = morph.pos.to_s.force_encoding("UTF-8")
    modified_word += morph.surface.to_s unless pos  =~ /記号/
  end
  return modified_word
end

def chunk_words(chunk)
  chunk_text = ''
  chunk.morphs.each do |morph|
    chunk_text += morph.surface.to_s
  end
  return chunk_text
end

def output_chunks(chunks)
  text = ''
  chunks.each do |chunk|
    chunk.morphs.each do |morph|
      text += morph.surface.to_s
    end
  end
  return text
  #puts text
end

def has_chank_pos(chunk, pos)
  chunk.morphs.each do |morph|
    next if morph.pos == nil
    return true if morph.pos.force_encoding("utf-8") == pos
  end
  return false
end

def modify_block(chunks)
  chunks.length.times do |i|
    text = ''
    chunks[i].morphs.length.times do |j|
      next if chunks[i].morphs[j] == nil || chunks[i].morphs[j+1] == nil
      next if chunks[i].morphs[j].pos1 == nil || chunks[i].morphs[j+1].pos == nil
      next unless chunks[i].morphs[j].pos1.force_encoding("utf-8") == 'サ変接続' && chunks[i].morphs[j+1].pos.force_encoding("utf-8") == '助詞'
      next if chunks[i+1] == nil

      text += chunk_words(chunks[i]) + chunk_words(chunks[i+1]) + "\t"
      # 係り元の探索
      particles = Array.new
      modify_blocks = Array.new

      next unless has_chank_pos(chunks[i+1], '動詞')
      chunks[i+1].srcs.each do |num|
        block = ''
        push_flag = false
        chunks[num.to_i].morphs.each do |morph|
          next if morph.surface == nil || morph.pos == nil || morph.pos1 == nil
          break if morph.pos1 == 'サ変接続'
          block += morph.surface

          particles.push(morph.surface) if morph.pos.force_encoding("utf-8") == '助詞' && push_flag == false
          push_flag = true if morph.pos.force_encoding("utf-8") == '助詞'
        end
        modify_blocks.push(block)
      end

      # 助詞を辞書順にソート
      text1 = ''
      text2 = ''
      particles.zip(modify_blocks).sort {|a, b| b[1].to_s <=> a[1].to_s}.map do | particle, modify_block|
        next if particle == nil || modify_block == nil
        text1 += particle + ' '
        text2 += modify_block + ' '
      end

      next if text1.strip == ''
      text += text1.force_encoding("utf-8") + "\t" + text2.force_encoding("utf-8")
      puts text unless text == ''
    end
  end
end

parser = CaboCha::Parser.new
chunks_lists = Array.new()
text = ''
open('neko.txt.cabocha', 'r').each do |word|
  word = word.gsub(/-*?D/, '').gsub('|', '').strip
  text += word.to_s unless word =~ /EOS/

  # 一文の区切り
  chunks = Array.new
  if word =~ /[。|EOS]/
    next if text.strip == ''
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
    chunks.push( Chunk.new(block, cabocha_sentence_data) )

    chunks_lists.push(chunks)

    chunks = Array.new
    #chunks.clear # 何故かclearで初期化するとchunks_listsに一つしか入らない
    text = ''
  end
end

#output_chunks(chunks_lists[5])

chunks_lists.each do |chunks|
  # 例題のパターン
  #if output_chunks(chunks) == '別段くるにも及ばんさと、主人は手紙に返事をする。'
  #  puts output_chunks(chunks)
  #  modify_block(chunks)
  #end
  modify_block(chunks)
end

