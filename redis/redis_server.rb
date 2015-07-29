#!/usr/bin/env ruby

require 'redis'
require 'json'
require '../service/calculator'

calculator = Calculator.new

redis_client = Redis.connect(url: 'redis://192.168.2.224:6379')

while true
	channel, request = redis_client.brpop('calc')

	request = JSON.parse request

	args = request['params'].unshift(request['method'])
	result = calculator.send *args

	reply = {
		'id' => request['id'],
		'result' => result,
		'jsonrpc' => '2.0'
	}

	redis_client.rpush(request['id'], JSON.generate(reply))

	redis_client.expire(request['id'], 30)
end
