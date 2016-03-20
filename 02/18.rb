=begin
18. 各行を3コラム目の数値の降順にソート
各行を3コラム目の数値の逆順で整列せよ（注意: 各行の内容は変更せずに並び替えよ）．確認にはsortコマンドを用いよ（この問題はコマンドで実行した時の結果と合わなくてもよい）．
=end

arr = Hash.new
File.open('hightemp.txt') do |file|
  file.each_line do |line|
    num = line.split("\t")[2].to_i
    arr[line] = num
  end
end

ans = %x(sort -r -k2 hightemp.txt )

arr.sort {|(line1, num1), (line2, num2)| num1 <=> num2 }.each do |line, num|
  puts line
end

puts

puts ans
