=begin
04. 元素記号
"Hi He Lied Because Boron Could Not Oxidize Fluorine. New Nations Might Also Sign Peace Security Clause. Arthur King Can."という文を単語に分解し，1, 5, 6, 7, 8, 9, 15, 16, 19番目の単語は先頭の1文字，それ以外の単語は先頭に2文字を取り出し，取り出した文字列から単語の位置（先頭から何番目の単語か）への連想配列（辞書型もしくはマップ型）を作成せよ．
=end

text = 'Hi He Lied Because Boron Could Not Oxidize Fluorine. New Nations Might Also Sign Peace Security Clause. Arthur King Can.'

arr = text.split(' ')
put_point = [ 1, 5, 6, 7, 8, 9, 15, 16 ,19 ]
hash_array = {}
insert_flag = false

i = 0
arr.each do |word|
  put_point.each do |point|
    if i == point
      hash_array[word[0]] = i
      insert_flag = true
    end
  end
  if ( insert_flag != true )
    hash_array[word[0..1]] = i
  else
    insert_flag = false
  end
  i = i + 1
end

puts hash_array["Hi"]
