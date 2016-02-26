# -*- coding: utf-8
require 'rubygems'
require 'natto'
require 'gruff'

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

count = Hash.new
mecab_data.each do | block_data |
  block_data.each do | word |
    next if word == '*'
    count[word[:base]] += 1 unless count[word[:base]] == nil
    count[word[:base]] = 1 if count[word[:base]] == nil
  end
end

# グラフの設定
g = Gruff::StackedBar.new()
g.title = '単語の出現頻度'
g.font = '/usr/share/fonts/opentype/ipafont-gothic/ipag.ttf'
g.title_font_size = 36
g.hide_title = false
g.y_axis_increment = 2000 #目盛の区切り
g.maximum_value = 15000
g.minimum_value = 0

i = 0
word_count = Array.new
label = Hash.new
count.sort{|(key1, cnt1), (key2, cnt2)| cnt2 <=> cnt1 }.map do | word, count |
  if word_count[count.to_i/1000] == nil
    word_count[count.to_i/1000] = 1
  else
    word_count[count.to_i/1000] += 1
  end
end

# nilへの処理
word_count.size.times { |i|
  word_count[i] = 0 unless word_count[i]
}

for num in 1..word_count.size
  label[num-1] = (num * 1000).to_s
end

g.data '出現頻度をとる単語の種類数', word_count
g.labels = label
g.marker_font_size = 16
g.write("38.png")
