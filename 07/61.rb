=begin
61. KVSの検索
60で構築したデータベースを用い，特定の（指定された）アーティストの活動場所を取得せよ．
=end

require "redis"

redis = Redis.new
while
  name = gets
  puts redis.get(name.chomp)
end

