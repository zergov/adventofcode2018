#!/usr/bin/env ruby

lines = File.readlines('input.example')

initial_state = lines.shift(2).join.strip.gsub("initial state: ", "")
initial_state = "...#{initial_state}...........".gsub(".", '_')
lines = lines.map {|pattern| pattern.gsub(".", "_")}

puts "initial_state: "
puts initial_state


result = initial_state
20.times do |n|
  result = lines.map(&:strip).inject(result) do |state, prevision|
    pattern, outcome = prevision.split('=>').map(&:strip)

    # state.gsub(pattern, "__#{outcome}__")
    state = state.gsub(/#{Regexp.quote(pattern)}/) do |match|
      match[2] = outcome
      match
    end
  end

  puts ""
  puts "after #{n}th generation"
  puts result
end

puts ""
puts "final:"
puts result
