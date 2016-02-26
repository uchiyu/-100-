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
key_count = Array.new
key_word = Hash.new
count.sort{|(key1, cnt1), (key2, cnt2)| cnt2 <=> cnt1 }.map do | word, count |
  if ( i >= 10 )
    break
  end
  next if word == '*'
  key_count.push(count.to_i)
  puts key_word[i] = word
  i = i + 1
end

g.data '出現頻度', key_count
g.labels = key_word
g.marker_font_size = 16
g.write("37.png")
