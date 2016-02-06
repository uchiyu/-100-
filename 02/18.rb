arr = Hash.new
File.open('hightemp.txt') do |file|
  file.each_line do |line|
    num = line.split("\t")[2].to_i
    arr[line] = num
  end
end

ans = %x(sort -r -k2 hightemp.txt )

arr.sort {|(line1, num1), (line2, num2)| num1 <=> num2 }.each do |line, num|
  puts line
end

puts

puts ans
