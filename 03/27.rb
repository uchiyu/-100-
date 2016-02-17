require 'json'

json_file_path = './report_britain.json'

basic_data = Hash.new
line_data = Array.new

open(json_file_path).each do |full_data|
  full_basic_data = full_data.match(/({{基礎情報).*?(注記).*?(}})/)
  full_basic_data = full_basic_data.to_s.gsub(/({{基礎情報).*?\|/, '').gsub(/}}$/, '')
  full_basic_data.to_s.split('\|').each do |data|
    line_data = data.to_s.delete('|').partition('=')
    tmp = line_data[2].to_s.delete('\\\\').gsub(/[']{2,5}/, '')
    basic_data[line_data[0].to_s.strip] = tmp.to_s.gsub(/[\[]+/, '').gsub(/[\]]+/, '')
    print line_data[0].to_s.strip, ' = ', tmp.to_s.gsub(/[\[]+/, '').gsub(/[\]]+/, '') + "\n"
  end
end

puts basic_data
