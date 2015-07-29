#!/usr/bin/env ruby

require 'redis'
require 'securerandom'
require 'json'

redis_client = Redis.connect(url: 'redis://192.168.2.224:6379')

request = {
	'id' => SecureRandom.hex,
	'jsonrpc' => '2.0',
	'method' => 'add',
	'params' => [1, 5.1]
}

redis_client.lpush('calc', JSON.generate(request))

channel, response = redis_client.brpop(request['id'], timeout=30)

puts "1+5.1=%.1f" % JSON.parse(response)['result']
