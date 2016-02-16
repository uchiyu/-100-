require 'json'

json_file_path = './report_britain.json'

basic_data = Hash.new
line_data = Array.new

open(json_file_path).each do |full_data|
  full_basic_data = full_data.match(/({{基礎情報).*(\\n}}\\n)/)
  full_basic_data = full_basic_data.to_s.gsub(/({{基礎情報).*?\|/, '').delete('\\n}}\\n')
  full_basic_data.to_s.split('\|').each do |data|
    line_data = data.to_s.partition('=')
    basic_data[line_data[0].to_s.strip] = line_data[2].to_s.delete('\\\\')
    puts
  end
end

puts basic_data
