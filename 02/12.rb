text1 = ''
text2 = ''
File.open('hightemp.txt') do |file|
  file.each do |line|
      text1 << line.to_s.split(/\t/)[0] + "\n"
      text2 << line.to_s.split(/\t/)[1] + "\n"
  end
end
File.write('col1.txt', text1 )
File.write('col2.txt', text2 )

ans1 = %x(cut -f 1 hightemp.txt)
ans2 = %x(cut -f 2 hightemp.txt)

if ans1 == File.read('col1.txt') && ans2 == File.read('col2.txt')
  puts 'Success'
else
  puts 'Failed'
end
