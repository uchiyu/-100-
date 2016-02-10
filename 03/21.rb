require 'json'

json_file_path = './report_britain.json'

tmp = Array.new
open(json_file_path).each do |data|
  puts data.to_s.scan(/\[Category:.*?\]/)
end

