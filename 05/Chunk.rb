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
