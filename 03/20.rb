=begin
20. JSONデータの読み込み
Wikipedia記事のJSONファイルを読み込み，「イギリス」に関する記事本文を表示せよ．問題21-29では，ここで抽出した記事本文に対して実行せよ．
=end

require 'json'

json_file_path = './jawiki-country.json'

open(json_file_path).each_line do |line|
  if line =~ /\"title\": \"イギリス"/
    File.open('./report_britain.json', 'a') do |io|
      io.puts(line)
    end
  end
end

