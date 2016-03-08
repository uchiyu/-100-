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

  sentences.each do |sentence|
    puts sentence
  end
end

text = ''
File.open('nlp.txt', 'r').each_line do |line|
  text += line
end
split_sentence(text)
