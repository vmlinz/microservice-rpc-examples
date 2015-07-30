#!/usr/bin/env ruby

require 'msgpack/rpc'

client = MessagePack::RPC::Client.new('127.0.0.1', 18800)

result = client.call(:add, 1, 5.1)

puts "1 + 5.1 = %.1f" % result
