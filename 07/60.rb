=begin
60. KVSの構築
Key-Value-Store (KVS) を用い，アーティスト名（name）から
活動場所（area）を検索するためのデータベースを構築せよ．
=end

require "json"
require "redis"

redis = Redis.new

file = open('artist.json')
file.each_line do |line|
  json = JSON.load(line)
  redis.set json['name'], json['area']
end

