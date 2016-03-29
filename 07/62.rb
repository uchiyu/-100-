=begin
62. KVS内の反復処理
60で構築したデータベースを用い，活動場所が「Japan」となっているアーティスト数を求めよ．
=end

require "redis"

redis = Redis.new
count = 0

redis.keys.each do |key|
  count = count + 1 if redis.get(key.chomp) == 'Japan'
  #print key, '  ', redis.get(key.chomp), "\n" if redis.get(key.chomp) == 'Japan'
end
puts count

