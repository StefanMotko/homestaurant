require 'elasticsearch'


if Rails.env.production?
  $elastic = Elasticsearch::Client.new url: ENV['BONSAI_URL'] ,log: true
else
  $elastic = Elasticsearch::Client.new log: true
end