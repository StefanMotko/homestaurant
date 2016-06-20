require 'redis'

$redis = Redis.new(host: 'localhost', port: 6379) if ENV['RAILS_ENV'] == 'development'
if ENV["REDISCLOUD_URL"]
  $redis = Redis.new(:url => ENV["REDISCLOUD_URL"])
end