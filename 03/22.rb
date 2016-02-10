require 'json'

json_file_path = './report_britain.json'

arr = Array.new
open(json_file_path).each do |data|
  arr = data.to_s.scan(/\[Category:.*?\]/)
end

arr.each do |category|
  puts category.delete('[Category:').delete(']')
end
