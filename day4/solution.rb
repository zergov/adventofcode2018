require 'date'

class GuardRecord
  attr_accessor :timestamp, :content, :minute
  def initialize(info)
    @timestamp = DateTime.parse(info[/\[.*?\]/].sub!('[', '').sub(']', ''))
    @content = info
    @minute = @timestamp.min
  end

  def woke_up?
    @content.include?("wakes")
  end

  def asleep?
    @content.include?("asleep")
  end

  def new_guard_id
    @content.partition('#').last.scan(/\d/).join('')
  end
end


records = []
File.readlines('input.txt').each do |line|
  records << GuardRecord.new(line)
end

sleep_time = {}
records = records.sort_by {|obj| obj.timestamp}

current_id = nil
last_awake = nil
records.each do |record|
  puts record.content
  if record.new_guard_id != ""
    current_id = record.new_guard_id
    sleep_time[current_id] = {} unless sleep_time[current_id]
  elsif record.asleep?
    last_awake = record.timestamp
  elsif record.woke_up?
    delta = ((record.timestamp - last_awake) * 24 * 60).to_i

    delta.times do |i|
      min = last_awake.min + i
      sleep_time[current_id][min] ? sleep_time[current_id][min] += 1 : sleep_time[current_id][min] = 1
    end
  end

  # puts sleep_time
end

besttotal = 0
bestid = nil
bestmin = 0
puts sleep_time
sleep_time.each do |id, minutes|
  total = 0
  count = minutes.each do |min, n|
    total += n
  end
  puts "#{id} total:#{total} | max minute: #{minutes.max_by{|k, v| v}}"
  mins = minutes.max_by{|k, v| v}
  if mins
    if total > besttotal
      besttotal = total
      bestmin = mins[0]
      bestid = id
    end
  end

end

puts bestmin
puts bestmin.to_i * bestid.to_i
