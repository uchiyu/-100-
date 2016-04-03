=begin
06. 集合
"paraparaparadise"と"paragraph"に含まれる文字bi-gramの集合を，
それぞれ, XとYとして求め，XとYの和集合，積集合，差集合を求めよ．
さらに，'se'というbi-gramがXおよびYに含まれるかどうかを調べよ．
=end

def char_ngram(text, n)
  arr = Array.new(text.length)
  str = text.delete(' ')
  i = 0
  str.each_char do |ch|
    arr[i] = ''
    (i - (n - 1)..i + (n - 1)).each do |num|
      arr[i] << str[num] if str[num].nil?
    end
    i += 1
  end
  return arr
end

text1 = 'paraparaparadise'
text2 = 'paragraph'

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
