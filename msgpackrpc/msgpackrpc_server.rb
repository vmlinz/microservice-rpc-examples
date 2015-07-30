#!/usr/bin/env ruby

require 'msgpack/rpc'
require '../service/calculator'

server = MessagePack::RPC::Server.new
server.listen('127.0.0.1', 18800, Calculator.new)
server.run