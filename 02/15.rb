text = ''
arr = Array.new
File.open('hightemp.txt') do |file|
  file.each do |line|
    arr.push(line)
  end
end

i = arr.size-ARGV[0].to_i
while i < arr.size
  text << arr[i]
  i = i + 1
end

ans = %x(tail -n #{ARGV[0]} hightemp.txt)

if text == ans
  puts 'Success'
  puts ans
else
  puts 'Failed'
  puts text
  puts
  puts ans
end
