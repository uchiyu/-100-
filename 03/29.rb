=begin
テンプレートの内容を利用し，国旗画像のURLを取得せよ．
（ヒント: MediaWiki APIのimageinfoを呼び出して，ファイル参照をURLに変換すればよい）
=end

# per

require 'json'
require 'net/http'
require 'uri'
require 'open-uri'

json_file_path = './report_britain.json'

basic_data = Hash.new
line_data = Array.new

open(json_file_path).each do |full_data|
  full_basic_data = full_data.match(/({{基礎情報).*?(注記).*?(}})/)
  full_basic_data = full_basic_data.to_s.gsub(/({{基礎情報).*?\|/, '').gsub(/}}$/, '')
  full_basic_data.to_s.split('\n|').each do |data|
    line_data = data.to_s.delete('|').partition('=')
    hash_data = line_data[2].to_s.delete('\\\\').gsub(/[']{2,5}/, '')
    hash_data = hash_data.to_s.gsub(/[\[]+/, '').gsub(/[\]]+/, '').gsub(/<ref.*?\/ref>/, '').gsub(/<ref.*?\/>/, '').gsub(/<br(| )\/>/, '').delete('{{').delete('}}')
    basic_data[line_data[0].to_s.strip] = hash_data
  end
end

name = basic_data['国旗画像'].strip.gsub(' ', '_')
uri = URI.parse("https://www.mediawiki.org/w/api.php?action=query&format=json&titles=Image:#{name}&prop=imageinfo&iiprop=url")
result = Net::HTTP.get(uri)
puts result['query']['pages']['-1']['imageinfo'][0]['url']


