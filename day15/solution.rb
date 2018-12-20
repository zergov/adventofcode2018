#!/usr/bin/env ruby
require './map'

input = File.readlines('input.example')
map = Map.new(input)

map.draw
