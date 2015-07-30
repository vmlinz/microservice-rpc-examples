#!/usr/bin/env ruby

require 'redis'
require 'securerandom'
require 'json'

class RedisRpcClient
	
	def initialize(redis_url, list_name)
		@redis_client = Redis.connect(url: redis_url)
		@list_name = list_name
	end

	def method_missing(name, *args)
		request = {
			'id' => SecureRandom.hex,
			'jsonrpc' => '2.0',
			'method' => name,
			'params' => args
		}

		@redis_client.lpush(@list_name, JSON.generate(request))

		channel, response = @redis_client.brpop(request['id'], timeout=30)

		JSON.parse(response)['result']
	end
end

client = RedisRpcClient.new('redis://192.168.2.224:6379', 'calc')

sum = client.add(1, 5.1)

puts "1 + 5.1 = %.1f" % sum