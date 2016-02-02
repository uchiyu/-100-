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
