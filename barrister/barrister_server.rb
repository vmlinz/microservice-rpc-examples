#!/usr/bin/env ruby

require 'sinatra'
require 'barrister'
require '../service/calculator'

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
