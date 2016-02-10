require 'json'

json_file_path = './report_britain.json'

arr = Array.new
num = Array.new
open(json_file_path).each do |data|
  data.split('\n').each do |line|
    tmp = line.to_s.scan(/:.*?\.jpg/i).to_s
    tmp.to_s.size
    if tmp != '[]'
      arr.push(tmp)
    end
  end
end

arr.each do |word|
  puts word.to_s.gsub(':', '')
end
