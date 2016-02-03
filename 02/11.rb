text1 = ''
File.open('hightemp.txt') do |file|
  file.each do |line|
    text1 << line.to_s.gsub(/\t/, ' ')
  end
end

text2 = %x(sed -e "s/\t/ /g" hightemp.txt)

if text1 == text2
  puts 'Success'
  puts text1
else
  puts 'Failed'
end
