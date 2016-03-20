=begin
13. col1.txtとcol2.txtをマージ
12で作ったcol1.txtとcol2.txtを結合し，元のファイルの1列目と2列目をタブ区切りで並べたテキストファイルを作成せよ．確認にはpasteコマンドを用いよ．
=end

result = ''
text1 = ''
text2 = ''
text1 = File.read('col1.txt').split("\n")
text2 = File.read('col2.txt').split("\n")

text1.zip(text2).each do |word1, word2|
  result << word1 + "\t" + word2 + "\n"
end
ans = %x(paste col1.txt col2.txt)

if ans == result
  puts 'Success'
  puts result
else
  puts 'Failed'
  puts result
  puts ans
end
