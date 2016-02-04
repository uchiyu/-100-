text = ''
arr = Array.new
File.open('hightemp.txt') do |file|
  file.each do |line|
    arr.push(line)
  end
end

i = 0
while i < ARGV[0].to_i
  text << arr[i]
  i = i + 1
end

ans = %x(head -n #{ARGV[0]} hightemp.txt)

if text == ans
  puts 'Success'
  puts ans
else
  puts 'Failed'
  puts text
  puts
  puts ans
end
