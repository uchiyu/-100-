=begin
17. １列目の文字列の異なり
1列目の文字列の種類（異なる文字列の集合）を求めよ．確認にはsort, uniqコマンドを用いよ．
=end

text = ''
arr = Array.new
File.open('hightemp.txt') do |file|
  file.each_line do |line|
    arr.push(line.split("\t")[0])
  end
end
puts arr.uniq.size
puts
puts ans = %x(cut -f 1 hightemp.txt | sort | uniq | wc -l )

