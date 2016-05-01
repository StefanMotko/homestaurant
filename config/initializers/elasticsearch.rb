require 'elasticsearch'

$elastic = Elasticsearch::Client.new log: true

ApplicationController.elastic_reindex