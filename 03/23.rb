require 'json'

json_file_path = './report_britain.json'

arr = Array.new
num = Array.new
open(json_file_path).each do |data|
  data.split('\n').each do |line|
    tmp = line.to_s.scan(/==.{1,20}==/)
    num = tmp.to_s.count('=')/2-1
    tmp = tmp.to_s.gsub(/=+?/, '')
    if num > 0
      print tmp.to_s, num
      puts
    end
  end
end

