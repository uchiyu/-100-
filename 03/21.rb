=begin
21. カテゴリ名を含む行を抽出
記事中でカテゴリ名を宣言している行を抽出せよ．
=end

require 'json'

json_file_path = './report_britain.json'

tmp = Array.new
open(json_file_path).each do |data|
    puts data.to_s.scan(/\[Category:.*?\n/)
end
