=begin
25. テンプレートの抽出
記事中に含まれる「基礎情報」テンプレートのフィールド名と値を抽出し，辞書オブジェクトとして格納せよ．
=end

require 'json'

json_file_path = './report_britain.json'

basic_data = Hash.new
line_data = Array.new

open(json_file_path).each do |full_data|
  full_basic_data = full_data.match(/({{基礎情報).*?(注記).*?(}})/)
  full_basic_data = full_basic_data.to_s.gsub(/({{基礎情報).*?\|/, '').gsub(/}}$/, '')
  full_basic_data.to_s.split('\|').each do |data|
    line_data = data.to_s.partition('=')
    basic_data[line_data[0].to_s.strip] = line_data[2].to_s.delete('\\\\')
  end
end

puts basic_data
