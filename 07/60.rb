require "json"
require "redis"

redis = Redis.new

file = open('artist.json')
file.each_line do |line|
  json = JSON.load(line)
  redis.set json['name'], json['area']
end

