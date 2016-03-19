require "redis"

redis = Redis.new
while
  name = gets
  puts redis.get(name.chomp)
end

