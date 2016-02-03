text = ''
i = 0
File.open('hightemp.txt') do |file|
  file.each do |line|
      text << line.to_s.split(/\t/)[0] + "\n"
  end
end

ans = %x(cut -f 1 hightemp.txt)

if text == ans
  puts 'Success'
  puts text
else
  puts 'Failed'
  puts text
  puts ans
end
