=begin
50. 文区切り
(. or ; or : or ? or !) → 空白文字 → 英大文字というパターンを文の区切りと見なし，入力された文書を1行1文の形式で出力せよ．
=end

def split_sentence(line)
  sentences = line.split(/([.|;|:|?|!] [A-Z])/) #文章の分割(()で囲むことで、文末と文頭の部分も分割されて含まれる)

  i = 0
  sentences.length.times do |num|
    if sentences[num] =~ /[.|;|:|?|!] [A-Z]/
      sentences[num-1].insert(-1, sentences[num].match(/[.|;|:|?|!]/).to_s) # 文末に追加
      sentences[num+1].insert(0, sentences[num].match(/[A-Z]/).to_s) # 文頭に追加
      sentences[num] = ''
    end
  end
  sentences.delete('') # 配列で文頭と文末を格納していた箇所を削除
  return sentences
end

#text = ''
#File.open('nlp.txt', 'r').each_line do |line|
#  text += line
#end
#puts split_sentence(text)
