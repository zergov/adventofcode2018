#!/usr/bin/env ruby

class Node
  attr_accessor :metadata, :children
  def initialize
    @metadata = []
    @children = []
  end

  def value
    if @children.empty?
      @metadata.reduce(:+)
    else
      @metadata
        .map { |index| @children[index - 1] }
        .compact
        .reduce(0) { |sum, node| sum + node.value }
    end
  end
end


def extract_metadata(stream)
  child_count, metadata_count = stream.shift(2)

  node = Node.new
  child_count.times do |n|
    child_node = extract_metadata(stream)
    node.children << child_node
  end

  node.metadata = stream.shift(metadata_count)
  return node
end

stream = File.read('input.txt').split(' ').map(&:to_i)
p extract_metadata(stream).value
