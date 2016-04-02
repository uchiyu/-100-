=begin
=end

require "json"
require "mongo"

client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'NLP100_Chapter07')
coll = client[:artist_data]

# データベースへの登録部分
file = open('artist.json')
file.each_line do |line|
  json = JSON.load(line)

  # 登録データの作成
  doc = {'id' => json['id'], 'gid' => json['gid'], 'name' => json['name'], 'sort_name' => json['sort_name'], 'area' => json['area'], 'aliases' => json['aliases'], 'begin' => json['begin'] , 'end' => json['end'], 'tags' => json['tags'], 'rating' => json['rating']}
  # mongoにデータに登録
  # puts doc
  result = coll.insert_one(doc)
end

# インデックスの登録
coll.indexes.create_one({ :name => 1 })
coll.indexes.create_one("aliases.name": 1)
coll.indexes.create_one("tags.value": 1)
coll.indexes.create_one("rating.value": 1)

