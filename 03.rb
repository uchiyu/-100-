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
