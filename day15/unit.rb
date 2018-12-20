class Unit
  attr_accessor :position

  def initialize(race, position)
    @race = race
    @position = position
    @attack_power = 3
    @hp = 200
  end

  def to_s
    return "G" if race == :goblin
    return "E" if race == :elf
  end

  def race
    return :goblin if @race == "G"
    return :elf if @race == "E"
  end

  def x
    @position[0]
  end

  def y
    @position[1]
  end
end
