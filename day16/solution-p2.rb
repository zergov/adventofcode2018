#!/usr/bin/env ruby

def addr(registers, opcode, a, b, c)
  registers[c] = registers[a] + registers[b]
  registers
end

def addi(registers, opcode, a, b, c)
  registers[c] = registers[a] + b
  registers
end

def mulr(registers, opcode, a, b, c)
  registers[c] = registers[a] * registers[b]
  registers
end

def muli(registers, opcode, a, b, c)
  registers[c] = registers[a] * b
  registers
end

def banr(registers, opcode, a, b, c)
  registers[c] = registers[a] & registers[b]
  registers
end

def bani(registers, opcode, a, b, c)
  registers[c] = registers[a] & b
  registers
end

def borr(registers, opcode, a, b, c)
  registers[c] = registers[a] | b
  registers
end

def bori(registers, opcode, a, b, c)
  registers[c] = registers[a] | b
  registers
end

def setr(registers, opcode, a, b, c)
  registers[c] = registers[a]
  registers
end

def seti(registers, opcode, a, b, c)
  registers[c] = a
  registers
end

def gtir(registers, opcode, a, b, c)
  registers[c] = a > registers[b] ? 1 : 0
  registers
end

def gtri(registers, opcode, a, b, c)
  registers[c] = registers[a] > b ? 1 : 0
  registers
end

def gtrr(registers, opcode, a, b, c)
  registers[c] = registers[a] > registers[b] ? 1 : 0
  registers
end

def eqir(registers, opcode, a, b, c)
  registers[c] = a == registers[b] ? 1 : 0
  registers
end

def eqri(registers, opcode, a, b, c)
  registers[c] = registers[a] == b ? 1 : 0
  registers
end

def eqrr(registers, opcode, a, b, c)
  registers[c] = registers[a] == registers[b] ? 1 : 0
  registers
end

functions = [
  method(:addr),
  method(:addi),
  method(:mulr),
  method(:muli),
  method(:banr),
  method(:bani),
  method(:borr),
  method(:bori),
  method(:setr),
  method(:seti),
  method(:gtir),
  method(:gtri),
  method(:gtrr),
  method(:eqir),
  method(:eqri),
  method(:eqrr),
]

blocks = File.readlines('input.txt').each_slice(4).map do |line|
  before, instruction, after = line.map(&:strip)

  before = eval(before.gsub("Before: ", ''))
  after = eval(after.gsub("After:  ", ''))
  instruction = instruction.split(' ').map(&:to_i)

  [before, instruction, after]
end

opcodes = {}

while opcodes.keys.size < functions.size do
  possibilities = blocks.map do |block|
    before, instruction, after = block
    opcode, a, b, c = instruction

    functions
      .select { |func| func.call(before.dup, opcode, a, b, c) == after }
      .map { |method| [method.name, opcode] }
      .select {|(func, code)| opcodes[code].nil?}
  end

    single = possibilities
      .select {|possibility| possibility.size == 1}
      .map(&:first)
      .uniq
      .group_by {|(func, code)| func}
      .select { |k, v| v.size == 1}
      .map(&:last)
      .flatten

    func, code = single
    opcodes[code] = func
    p opcodes
end

