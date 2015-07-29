#!/usr/bin/env ruby

require 'bunny'
require 'json'
require '../service/calculator'

calculator = Calculator.new

conn = Bunny.new(:hostname => "192.168.2.224")
conn.start

ch = conn.create_channel
q = ch.queue('calc')
x = ch.default_exchange

q.subscribe(block: true) do |delivery_info, properties, payload|
	req_message = JSON.parse payload

	print req_message

	result = calculator.send *(req_message['params'].unshift(req_message['method']))

	reply = {
		'id' => req_message['id'],
		'result' => result,
		'jsonrpc' => '2.0'
	}

	x.publish(JSON.generate(reply), {
		routing_key: properties.reply_to,
		correlation_id: properties.correlation_id
		})
end
