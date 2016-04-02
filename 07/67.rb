=begin
67. 複数のドキュメントの取得
特定の（指定した）別名を持つアーティストを検索せよ．
=end

require "json"
require "mongo"

client = Mongo::Client.new(['127.0.0.1:27017'], :database => 'NLP100_Chapter07')
coll = client[:artist_data]

while
  name = gets
  puts
  coll.find({"aliases.name":name.chomp}).each { |row| print row.inspect, "\n\n" }
  #puts coll.find({"aliases.name":name.chomp})
end
