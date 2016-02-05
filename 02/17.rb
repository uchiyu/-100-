text = ''
arr = Array.new
File.open('hightemp.txt') do |file|
  file.each_line do |line|
    arr.push(line.split("\t")[0])
  end
end
puts arr.uniq.size
puts
puts ans = %x(cut -f 1 hightemp.txt | sort | uniq | wc -l )

