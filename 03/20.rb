require 'json'

json_file_path = './jawiki-country.json'

open(json_file_path).each_line do |line|
  if line =~ /\"title\": \"イギリス"/
    File.open('./report_britain.json', 'a') do |io|
      io.puts(line)
    end
  end
end

