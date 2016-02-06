arr = Hash.new
File.open('hightemp.txt') do |file|
  file.each_line do |line|
    tmp = line.split("\t")[0]
    if arr[tmp] == nil
      arr[tmp] = 1
    else
      arr[tmp] = arr[tmp] + 1
    end
  end
end

ans = %x( sort hightemp.txt | cut -f1 | uniq -c | sort -d -r )

arr.sort {|(col1, num1), (col2, num2)| num2 <=> num1 }.each do |col, num|
  print col, ' ', num
  puts
end

puts

puts ans
