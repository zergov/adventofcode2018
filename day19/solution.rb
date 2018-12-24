#!/usr/bin/env ruby

def addr(registers, a, b, c)
  registers[c] = registers[a] + registers[b]
  registers
end

def addi(registers, a, b, c)
  registers[c] = registers[a] + b
  registers
end

def mulr(registers, a, b, c)
  registers[c] = registers[a] * registers[b]
  registers
end

def muli(registers, a, b, c)
  registers[c] = registers[a] * b
  registers
end

def banr(registers, a, b, c)
  registers[c] = registers[a] & registers[b]
  registers
end

def bani(registers, a, b, c)
  registers[c] = registers[a] & b
  registers
end

def borr(registers, a, b, c)
  registers[c] = registers[a] | b
  registers
end

def bori(registers, a, b, c)
  registers[c] = registers[a] | b
  registers
end

def setr(registers, a, b, c)
  registers[c] = registers[a]
  registers
end

def seti(registers, a, b, c)
  registers[c] = a
  registers
end

def gtir(registers, a, b, c)
  registers[c] = a > registers[b] ? 1 : 0
  registers
end

def gtri(registers, a, b, c)
  registers[c] = registers[a] > b ? 1 : 0
  registers
end

def gtrr(registers, a, b, c)
  registers[c] = registers[a] > registers[b] ? 1 : 0
  registers
end

def eqir(registers, a, b, c)
  registers[c] = a == registers[b] ? 1 : 0
  registers
end

def eqri(registers, a, b, c)
  registers[c] = registers[a] == b ? 1 : 0
  registers
end

def eqrr(registers, a, b, c)
  registers[c] = registers[a] == registers[b] ? 1 : 0
  registers
end


def run(registers)
  program = File.readlines('input.txt').map(&:strip)

  previous = registers
  ip_index = program.shift.split.last.to_i
  p ip_index

  loop {
    instruction = program[registers[ip_index]]

    command, a, b, c = instruction.split
    a, b, c = [a, b, c].map(&:to_i)
    eval("#{command}(registers, a, b, c)")

    previous = registers.dup
    registers[ip_index] += 1
    program[registers[ip_index]] # will explode eventually
  }
rescue
  p previous
  puts "answer: #{previous[0]}"
end

puts "part1: #{run([0, 0, 0, 0, 0, 0])}"
# puts "part2: #{run([1, 0, 0, 0, 0, 0])}" will never finish
