$redis = Redis.new(host: 'localhost', port: 6379) if ENV['RAILS_ENV'] == 'development'
