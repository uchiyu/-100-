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

mecab_data.each do | block_data |
  for i in 1..block_data.length-2
    if block_data[i][:surface] == 'の'
      if block_data[i-1][:pos] == '名詞' && block_data[i+1][:pos] == '名詞'
        print block_data[i-1][:surface], block_data[i][:surface], block_data[i+1][:surface]
        puts
      end
    end
  end
end
