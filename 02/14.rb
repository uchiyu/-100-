=begin
14. 先頭からN行を出力
自然数Nをコマンドライン引数などの手段で受け取り，入力のうち先頭のN行だけを表示せよ．確認にはheadコマンドを用いよ．
=end

text = ''
arr = Array.new
File.open('hightemp.txt') do |file|
  file.each do |line|
    arr.push(line)
  end
end

i = 0
while i < ARGV[0].to_i
  text << arr[i]
  i = i + 1
end

ans = %x(head -n #{ARGV[0]} hightemp.txt)

if text == ans
  puts 'Success'
  puts ans
else
  puts 'Failed'
  puts text
  puts
  puts ans
end
