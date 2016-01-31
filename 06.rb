def char_bi_gram(text)
  arr = Array.new(text.length) { Array.new(text.length) }
  str = text.gsub(' ', '')
  i = 0
  str.each_char do |ch|
    if i == 0
      arr[i][1] = ch[i]
      arr[i][2] = ch[i+1]
    elsif i == arr.length-1
      arr[i][0] = ch[i-1]
      arr[i][1] = ch[i]
    else
      arr[i][0] = ch[i-1]
      arr[i][1] = ch[i]
      arr[i][2] = ch[i+1]
    end
    i = i + 1
  end
  return arr
end

text1 = "paraparaparadise"
text2 = "paragraph"

arr1 = char_bi_gram(text1)


