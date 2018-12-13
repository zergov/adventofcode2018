#!/usr/bin/env ruby

require 'set'
require 'json'

all_tasks = Set.new
requirements = {}

File.readlines('input.txt').each do |instruction|
  requirement = instruction.split(' ')[1]
  task = instruction.split(' ')[7]

  all_tasks << requirement
  all_tasks << task

  if requirements.include?(task)
    requirements[task] << requirement
  else
    requirements[task] = [requirement]
  end
end

workers = [nil, nil]
todos = []
while !all_tasks.empty?
  todo = (all_tasks - requirements.keys).to_a
  todo = todo.sort!.first
  todos << todo
  all_tasks.delete(todo)

  requirements.values.each do |values|
    values.delete(todo)
  end

  requirements.delete_if do |k, v|
    v.empty?
  end

  p all_tasks
end

puts todos.join
