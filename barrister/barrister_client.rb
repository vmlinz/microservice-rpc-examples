#!/usr/bin/env ruby

require 'barrister'

trans = Barrister::HttpTransport.new('http://localhost:4567/calc')

client = Barrister::Client.new(trans)

puts "1 + 5.1 = %.1f" % client.Calculator.add(1, 5.1)
