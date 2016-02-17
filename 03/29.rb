=begin
テンプレートの内容を利用し，国旗画像のURLを取得せよ．
（ヒント: MediaWiki APIのimageinfoを呼び出して，ファイル参照をURLに変換すればよい）
=end

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
  full_basic_data.to_s.split('\|').each do |data|
    line_data = data.to_s.delete('|').partition('=')
    hash = line_data[2].to_s.delete('\\\\').gsub(/[']{2,5}/, '')
    hash = hash.to_s.gsub(/[\[]+/, '').gsub(/[\]]+/, '').gsub(/<ref.*?\/ref>/, '').gsub(/<ref.*?\/>/, '').gsub(/<br(| )\/>/, '').delete('{{')
    basic_data[line_data[0].to_s.strip] = hash
  end
end

name = basic_data['国旗画像']#.strip.gsub(' ', '_')
puts name
#uri = URI.parse(URI.escape("http://www.mediawiki.org/w/api.php?format=json&action=query&titles=Image:#{name}&prop=imageinfo&iiprop=url"))
#puts JSON.parse(Net::HTTP.get(uri))['query']['pages']['-1']['imageinfo'][0]['url']


