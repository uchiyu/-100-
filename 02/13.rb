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
