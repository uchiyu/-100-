=begin
49. 名詞間の係り受けパスの抽出
文中のすべての名詞句のペアを結ぶ最短係り受けパスを抽出せよ．ただし，名詞句ペアの文節番号がii<ji<j）のとき，係り受けパスは以下の仕様を満たすものとする．

問題48と同様に，パスは開始文節から終了文節に至るまでの各文節の表現（表層形の形態素列）を"->"で連結して表現する
文節iとjに含まれる名詞句はそれぞれ，XとYに置換する
=end


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
    next if morph.pos == nil
    chunk_text += morph.surface.to_s unless morph.pos.force_encoding("utf-8") == '記号'
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

# 経路の生成------------------------------------------------------------
def root_path(chunks, first_noun_num, second_noun_num, common_routes, include_second_noun)

  path = ''
  # 1の経路上に2がある場合
  if include_second_noun
    path += chunk_words_noun_change(chunks[first_noun_num], 'X')
    route = ''
    next_num = chunks[first_noun_num].dst.delete('D').to_i
    path += root_routes(route, chunks, next_num, second_noun_num)
    puts path
  # 1の経路上に2がない場合
  else
    path += include_common_root(chunks, first_noun_num, second_noun_num, common_routes[0].to_i)
    puts path
  end
end

# 経路に共通部分がない場合----------------------------------------------
def include_common_root(chunks, first_noun_num, second_noun_num, common_route)
  text = ''
  # Xの差異部分
  text += chunk_words_noun_change(chunks[first_noun_num], 'X')
  route = ''
  text += different_route(route, chunks, chunks[first_noun_num].dst.to_i, common_route)
  text += ' | '
  # Yの差異部分
  text += chunk_words_noun_change(chunks[second_noun_num], 'Y')
  text += different_route(route, chunks, chunks[second_noun_num].dst.to_i, common_route)
  text += ' | '
  # 共通部分
  text += chunk_words(chunks[common_route])
end

def different_route(route, chunks, next_dst, common_route_num)
  return route if next_dst == common_route_num
  route += ' -> ' + chunk_words(chunks[next_dst])
  different_route(route, chunks, chunks[next_dst].dst.to_i, common_route_num)
end

# 経路に共通部分がない場合----------------------------------------------
def root_routes(route, chunks, dst, second_noun_num)
  route += ' -> ' + chunk_words_y( chunks, dst, second_noun_num)
  return route if dst == second_noun_num
  return route if chunks[dst].dst.delete('D').to_i == -1
  root_routes(route, chunks, chunks[dst].dst.delete('D').to_i, second_noun_num)
end

def chunk_words_noun_change(chunk, change_char)
  chunk_text = ''
  appear_noun = false
  chunk.morphs.each do |morph|
    next if morph.pos == nil

    if morph.pos.force_encoding("utf-8") == '名詞' && appear_noun == false
      chunk_text += change_char
      appear_noun = true
      next
    end

    chunk_text += morph.surface.to_s unless morph.pos.force_encoding("utf-8") == '記号'
  end
  return chunk_text
end

def chunk_words_y(chunks, dst, second_noun_num)
  chunk_text = ''
  appear_noun = false

  chunks[dst].morphs.each do |morph|
    next if morph.pos == nil
    if dst == second_noun_num && morph.pos.force_encoding("utf-8") == '名詞' && appear_noun == false
      chunk_text += 'Y'
      appear_noun = true
      break
    end
    chunk_text += morph.surface.to_s unless morph.pos.force_encoding("utf-8") == '記号'
  end
  return chunk_text
end

# 49 名詞間の係り受けパスの抽出----------------------------------------
def noun_modify_path(chunks)
  noun_chunk_places = Array.new
  include_second_noun = false # 1の経路上に2があるか

  # 名詞を含むチャンクの探索
  noun_chunk_places = find_noun_chunk(chunks)

  noun_chunk_places.size.times do |num1|
    # ひとつ目の名詞の経路
    first_noun_route = Array.new
    first_noun_route = find_route(first_noun_route, chunks, chunks[noun_chunk_places[num1]])
    (num1+1..noun_chunk_places.size-1).each do |num2|
      # ふたつ目の名詞の経路
      second_noun_route = Array.new
      second_noun_route = find_route(second_noun_route, chunks, chunks[noun_chunk_places[num2]])
      
      include_second_noun = first_noun_route.include?(noun_chunk_places[num2])

      #二つの経路の共通部分
      common_routes = Array.new
      common_routes = find_common_route(chunks, first_noun_route, second_noun_route)

      # 経路を出力
      root_path(chunks, noun_chunk_places[num1], noun_chunk_places[num2], common_routes, include_second_noun)
      
    end
  end
end

# nounを含むチャンクの場所の配列を返却
def find_noun_chunk(chunks)
  noun_chunk_places = Array.new
  chunks.size.times do |num|
    chunks[num].morphs.each do |morph|
      next if morph.pos == nil
      if morph.pos.force_encoding("utf-8") == '名詞'
        noun_chunk_places.push(num)
        break
      end
    end
  end
  return noun_chunk_places
end

# チャンクからの経路を探索して、経路番号の配列を返却
def find_route(route, chunks, chunk)
  return route if chunk.dst.delete('D').to_i == -1
  route.push(chunk.dst.delete('D').to_i)
  find_route(route, chunks, chunks[chunk.dst.delete('D').to_i])
end

def find_common_route(chunks, first_noun_route, second_noun_route)
  common_routes = Array.new
  first_noun_route.each do |route1|
    second_noun_route.each do |route2|
      next if route1.to_i == -1 || route2.to_i == -1
      common_routes.push(route1.to_i) if route1.to_i == route2.to_i
    end
  end

  return common_routes
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

output_chunks(chunks_lists[5])
noun_modify_path(chunks_lists[5])

