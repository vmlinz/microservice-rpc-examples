#!/usr/bin/env ruby

require 'bunny'
require 'securerandom'
require 'json'

conn = Bunny.new(:hostname => "192.168.2.224")
conn.start

ch = conn.create_channel
q = ch.queue('calc', auto_delete: false)
x = ch.default_exchange

req_message = {
	'id' => SecureRandom.hex,
	'jsonrpc' => '2.0',
	'method' => 'add',
	'params' => [1, 5.1]
}

response = nil

reply_q = ch.queue('', exclusive: true)

x.publish(JSON.generate(req_message), {
	correlation_id: req_message['id'],
	reply_to: reply_q.name,
	routing_key: q.name
	})

reply_q.subscribe(block: true) do |delivery_info, properties, payload|
	if properties[:correlation_id] == req_message['id']
		response = payload
		delivery_info.consumer.cancel
	end
end

JSON.parse(response)['message']
puts "1 + 5.1 = %.1f" % JSON.parse(response)['result']
