=begin
22. カテゴリ名の抽出
記事のカテゴリ名を（行単位ではなく名前で）抽出せよ．
=end

require 'json'

json_file_path = './report_britain.json'

arr = Array.new
open(json_file_path).each do |data|
  arr = data.to_s.scan(/\[Category:.*?\]/)
end

arr.each do |category|
  puts category.delete('[Category:').delete(']')
end
