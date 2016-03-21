=begin
63. オブジェクトを値に格納したKVS
KVSを用い，アーティスト名（name）からタグと被タグ数（タグ付けされた回数）のリストを検索するためのデータベースを構築せよ．さらに，ここで構築したデータベースを用い，アーティスト名からタグと被タグ数を検索せよ．
=end

require "json"
require "redis"

redis = Redis.new

# データベースへの登録部分
# 追加登録なので事前にデータを消しておく
#file = open('artist.json')
#file.each_line do |line|
#  tags = Array.new
#  json = JSON.load(line)
#
#  next if json['tags'] == nil
#
#  # tagsの例 : {"count"=>1, "value"=>"country"}
#  #            {"count"=>1, "value"=>"england"}
#  tags = json['tags']
#  # redisにcountとvalueを順番にリストとして追加
#  tags.each do |hash|
#    redis.rpush json['name'], hash["count"]
#    redis.rpush json['name'], hash["value"]
#  end
#end

while 1
  name = gets

  tags = redis.lrange(name.chomp, 0, redis.llen(name.chomp))
  tags.length.times do |num|
    print tags[num], "\t"
    puts if num%2 == 1
  end
  puts
end
