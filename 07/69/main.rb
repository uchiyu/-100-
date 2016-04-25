=begin
69. Webアプリケーションの作成
ユーザから入力された検索条件に合致するアーティストの情報を表示するWebアプリケーションを作成せよ．アーティスト名，アーティストの別名，タグ等で検索条件を指定し，アーティスト情報のリストをレーティングの高い順などで整列して表示せよ．
=end

require 'sinatra'
require 'sinatra/reloader'
require 'slim'
require 'mongo'

class Application < Sinatra::Base
end

client = Mongo::Client.new(['127.0.0.1:27017'], :database => 'NLP100_Chapter07')
coll = client[:artist_data]

helpers do
  include Rack::Utils
end

before do
  @result = nil
end

get '/' do
  erb :search
end

post '/' do
  elem = params['elem']
  key = params['body']

  if elem == 'name'
    @result = coll.find('name': key).sort('rating.count': -1)
  elsif elem == 'tag'
    @result = coll.find('tags.value': 'dance').sort('rating.count': -1)
  end
  erb :search
end
