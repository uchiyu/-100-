=begin
09. Typoglycemia
スペースで区切られた単語列に対して，各単語の先頭と末尾の文字は残し，それ以外の文字の順序をランダムに並び替えるプログラムを作成せよ．ただし，長さが４以下の単語は並び替えないこととする．適当な英語の文（例えば"I couldn't believe that I could actually understand what I was reading : the phenomenal power of the human mind ."）を与え，その実行結果を確認せよ．
=end

def swap( arr, x, y)
  tmp = arr[x]
  arr[x] = arr[y]
  arr[y] = tmp
end

def swap_word(text)
  arr = text.split(' ')
  i = 0
  while i < 10
    swap(arr, rand(1..arr.length-2), rand(1..arr.length-2))
    i = i + 1
  end
  return arr.join(' ')
end

text = "I couldn't believe that I could actually understand what I was reading : the phenomenal power of the human mind ."
puts swap_word(text)
