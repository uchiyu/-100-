=begin
65. MongoDBの検索
MongoDBのインタラクティブシェルを用いて，"Queen"というアーティストに関する情報を取得せよ．さらに，これと同様の処理を行うプログラムを実装せよ．
=end

# mongodbのコンソールでのコマンド
# db.artist_data.find({"name":"Queen"})

require "json"
require "mongo"

client = Mongo::Client.new(['127.0.0.1:27017'], :database => 'NLP100_Chapter07')
coll = client[:artist_data]

coll.find({"name":"Queen"}).each { |row| print row.inspect, "\n\n" }
