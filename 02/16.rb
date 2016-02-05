text = ''
arr = Array.new
File.open('hightemp.txt') do |file|
  file.each_line do |line|
    arr.push(line)
  end
end

ans = Array.new((arr.size/(ARGV[0].to_i))+1, '')
i = 0
while i < arr.size
  ans[i/(ARGV[0].to_i)] = ans[i/(ARGV[0].to_i)] + arr[i]
  i = i + 1
end

puts ans[0]
puts
puts ans[ans.size-1]
# ans = %x(split -l #{ARGV[0]} hightemp.txt )

