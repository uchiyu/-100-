require 'cabocha'

class Morph
  def initialize(mecab_line_data)
    line_data = mecab_line_data.split(/\t/)
    return if line_data[0] =~ /[EOS]/
    line_data[0] = line_data[0].force_encoding("utf-8").gsub('　', '') # 全角空白の削除
    return if line_data[0] == ''
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
      if cabocha_inf[0] == '*' # 文節の区切り
        @dst = cabocha_inf[2]

        # srcsリストの作成
        srcs_list = Array.new
        cabocha_data.each_line do |tmp| # cabochaから得られたデータ
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
  puts text
end

def modify_block(chunks)
  chunks.each do |chunk|
    text = ''
    chunk.morphs.each do |morph|
      next if morph.pos == nil
      next unless morph.pos.force_encoding("utf-8") == '動詞'
      text += morph.base + "\t"
      # 係り元の探索
      particles = Array.new
      modify_blocks = Array.new
      chunk.srcs.each do |num|
        block = ''
        chunks[num.to_i].morphs.each do |morph|
          block += morph.surface
          particles.push(morph.base) if morph.pos.force_encoding("utf-8") == '助詞'
        end
        modify_blocks.push(block)
      end

      # 助詞を辞書順にソート
      text1 = ''
      text2 = ''
      particles.zip(modify_blocks).sort {|a, b| b[1] <=> a[1]}.map do | particle, modify_block|
        text1 += particle + ' '
        text2 += modify_block + ' '
      end
      text += text1 + "\t" + text2.force_encoding("ascii-8bit")
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

modify_block(chunks_lists[5])

