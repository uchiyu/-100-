=begin
39. Zipfの法則
単語の出現頻度順位を横軸，その出現頻度を縦軸として，両対数グラフをプロットせよ．
=end

require 'rubygems'
require 'gnuplot'

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

key_count = Array.new
count.sort{|(key1, cnt1), (key2, cnt2)| cnt1 <=> cnt2 }.map do | word, count |
  next if word == '*'
  key_count.push(count.to_i)
end

horizontal = Array.new
key_count.size.times do |i|
  horizontal[i+1] = i+1
end

## グラフの設定
Gnuplot.open { |gp|
  Gnuplot::Plot.new(gp) { |plot|
    plot.terminal("png")
    plot.output("39.png")
    plot.title("Zipf")
    plot.logscale("y")

    # プロットするデータをDataSetへ込めてPlot#dataに設定する
    plot.data << Gnuplot::DataSet.new([horizontal, key_count]) { |ds|
      ds.with = "lines"
      ds.notitle
    }
  }
}


