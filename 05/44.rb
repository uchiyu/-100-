=begin
44. 係り受け木の可視化
与えられた文の係り受け木を有向グラフとして可視化せよ．可視化には，係り受け木をDOT言語に変換し，Graphvizを用いるとよい．また，Pythonから有向グラフを直接的に可視化するには，pydotを使うとよい．
=end

require 'cabocha'
require 'gviz'

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

def make_direction_graph(chunks)
  gv = Gviz.new
  i = 0
  chunks.each do |chunk|
    gv.subgraph do |sub_graph|
      modify_words_id = Array.new # 修飾語のグラフの要素ID
      modified_word = '' # 修飾される語
      modify_words = Array.new # 修飾する語を格納する配列

      # 各グラフの生成
      # 係り元の探索
      modified_word = chunk_words(chunk) #係り先の文字
      next if chunk.srcs.size <= 0
      #global label %I(#{modified_word}) # グラフのタイトル
      # 修飾元の語を配列に格納
      chunk.srcs.each do |num|
        tmp = chunk_words(chunks[num.to_i]).to_s.strip# 係り元の語を抽出
        next if tmp == ''
        modify_words.push(tmp) # 係り元の語を追加

        # idを生成・追加  ([modify sub_graph番号-要素番号] の順番)
        modify_words_id.push("modify" + i.to_s + "and" + modify_words.size.to_s)
      end
      # グラフへ要素の追加
      modify_words_id.each do |id|
        sub_graph.add %I(#{id}) => "modified#{i}".to_sym
      end

      # グラフのノードの編集
      modify_words_id.zip(modify_words).map do |id, word|
        print id, '  ', word, "\n"
        sub_graph.node id.to_sym, label: word
      end
      print "modified#{i}  ", modified_word, "\n"
      sub_graph.node "modified#{i}".to_sym, label: modified_word
      i = i + 1
    end
  end
  gv.save :graph44, :png
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

make_direction_graph(chunks_lists[4])

