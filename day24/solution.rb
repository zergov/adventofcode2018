#!/usr/bin/env ruby

class Group
  def initialize(unit_count:, hp:, attack_damage:, attack_type:, initiative:, weaknesses:, immunities:)
    @unit_count = unit_count
    @hp = hp
    @attack_damage = attack_damage
    @attack_type = attack_type
    @initiative = initiative
    @weaknesses = weaknesses
    @immunities = immunities
    @effective_power = unit_count * attack_damage
  end
end

immune_system = <<-IMMUNE_SYSTEM
2086 units each with 11953 hit points with an attack that does 46 cold damage at initiative 13
329 units each with 3402 hit points (weak to bludgeoning) with an attack that does 90 slashing damage at initiative 1
414 units each with 7103 hit points (weak to bludgeoning; immune to radiation) with an attack that does 170 radiation damage at initiative 4
2205 units each with 7118 hit points (immune to cold; weak to fire) with an attack that does 26 radiation damage at initiative 18
234 units each with 9284 hit points (weak to slashing; immune to cold, fire) with an attack that does 287 radiation damage at initiative 12
6460 units each with 10804 hit points (weak to fire) with an attack that does 15 slashing damage at initiative 11
79 units each with 1935 hit points with an attack that does 244 radiation damage at initiative 8
919 units each with 2403 hit points (weak to fire) with an attack that does 22 slashing damage at initiative 2
172 units each with 1439 hit points (weak to slashing; immune to cold, fire) with an attack that does 69 slashing damage at initiative 3
1721 units each with 2792 hit points (weak to radiation, fire) with an attack that does 13 cold damage at initiative 16
IMMUNE_SYSTEM

infection = <<-INFECTION
1721 units each with 29925 hit points (weak to cold, radiation; immune to slashing) with an attack that does 34 radiation damage at initiative 5
6351 units each with 21460 hit points (weak to cold) with an attack that does 6 slashing damage at initiative 15
958 units each with 48155 hit points (weak to bludgeoning) with an attack that does 93 radiation damage at initiative 7
288 units each with 41029 hit points (immune to bludgeoning; weak to radiation) with an attack that does 279 cold damage at initiative 20
3310 units each with 38913 hit points with an attack that does 21 radiation damage at initiative 19
3886 units each with 16567 hit points (immune to bludgeoning, cold) with an attack that does 7 cold damage at initiative 9
39 units each with 7078 hit points with an attack that does 300 bludgeoning damage at initiative 14
241 units each with 40635 hit points (weak to cold) with an attack that does 304 fire damage at initiative 6
7990 units each with 7747 hit points (immune to fire) with an attack that does 1 radiation damage at initiative 10
80 units each with 30196 hit points (weak to fire) with an attack that does 702 bludgeoning damage at initiative 17
INFECTION

def create_army(army_definition)
  army_definition.split("\n").map do |group_definition|
    weaknesses = []
    immunities = []
    definition = group_definition.split
    if group_definition.include?("(")
      defenses = group_definition.match(/\((.*?)\)/).captures.join.split(';').map(&:strip)
      defenses.each do |defense|
        if defense.include?("weak to")
          weaknesses = defense.gsub("weak to", "").split(',').map(&:strip)
        end
        if defense.include?("immune to")
          immunities = defense.gsub("immune to", "").split(',').map(&:strip)
        end
      end
    end

    Group.new(
      unit_count: definition[0].to_i,
      hp: definition[4].to_i,
      attack_damage: definition[-6].to_i,
      attack_type: definition[-5],
      initiative: definition[-1].to_i,
      weaknesses: weaknesses,
      immunities: immunities
    )
  end
end

immune_system_army = create_army(immune_system)
infection_army = create_army(infection)
