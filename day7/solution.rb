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

worker_count = 5
workers = []
todos = []
time = 0

while !all_tasks.empty?
  available_steps = (all_tasks - requirements.keys).to_a.sort
  available_steps.select! {|step| !workers.any? {|activestep, time| step == activestep }}
  p available_steps
  available_steps.each {|step| workers << [step, (step.ord - 64) + 60] if workers.size < worker_count }

  p workers
  # time is running
  workers = workers.map {|step, time| [step, time -= 1]}
  # remove done steps from requirements
  workers.select {|step, time| time == 0}.each do |step, time|
    todos << step
    requirements.values.each do |values|
      values.delete(step)
    end
    all_tasks.delete(step)
  end

  workers = workers.select {|step, time| time > 0}

  # delete empty requirements
  requirements.delete_if { |k, v| v.empty? }
  time += 1
end

puts time
