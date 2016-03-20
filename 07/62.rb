=begin
62. KVS内の反復処理
60で構築したデータベースを用い，活動場所が「Japan」となっているアーティスト数を求めよ．
=end

require "redis"

redis = Redis.new
while
  name = gets
  puts redis.get(name.chomp)
end

