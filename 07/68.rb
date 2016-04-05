=begin
68. ソート
"dance"というタグを付与されたアーティストの中でレーティングの投票数が多いアーティスト・トップ10を求めよ．
=end

require 'json'
require 'mongo'

client = Mongo::Client.new(['127.0.0.1:27017'], :database => 'NLP100_Chapter07')
coll = client[:artist_data]

i = 1
coll.find({ 'tags.value':'dance' }).sort({'rating.count':-1}).limit(10).each do |row|
  print i, ' : ', row['name'], "\n\n"
  i += 1
end
