#!/usr/bin/env ruby

require 'sinatra'
require 'json'
require '../service/calculator'

calculator = Calculator.new

post '/calc' do
	req = JSON.parse(request.body.read)

	args = req['params'].unshift(req['method'])
	result = calculator.send *args

	status 200
	headers 'Content-Type' => 'application/json'

	JSON.generate({
		'id' => req['id'],
		'result' => result,
		'jsonrpc' => '2.0'
		})
end