def char_ngram(text, n)
  arr = Array.new(text.length)
  str = text.gsub(' ', '')
  i = 0
  str.each_char do |ch|
    arr[i] = ''
    for num in i-(n-1)..i+(n-1)
      if ( str[num] != nil )
        arr[i] << str[num]
      end
    end
    i = i + 1
  end
  return arr
end

text1 = "paraparaparadise"
text2 = "paragraph"

arr1 = char_ngram(text1, 2)
arr2 = char_ngram(text2, 2)

# 各要素
p arr1
p arr2
puts
# 和集合
p arr1 | arr2
# 差集合
p arr1 - arr2
# 積集合
p arr1 & arr2
