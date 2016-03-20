=begin
31. 動詞
動詞の表層形をすべて抽出せよ．
=end

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

mecab_data.each do | block_data |
  block_data.each do | data |
    if data[:pos] == '動詞'
      puts data[:surface]
    end
  end
end
