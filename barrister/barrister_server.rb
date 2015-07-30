#!/usr/bin/env ruby

require 'sinatra'
require 'barrister'

class Calculator

	def add(a, b)
		a + b
	end

	def substract(a, b)
		a - b
	end
	
end

contract = Barrister::contract_from_file('calc.json')
server = Barrister::Server.new(contract)

server.add_handler("Calculator", Calculator.new)

post '/calc' do
	request.body.rewind
	response = server.handle_json(request.body.read)

	status 200
	headers 'Content-Type' => 'application/json'

	response
end