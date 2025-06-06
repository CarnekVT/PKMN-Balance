# NOTE: "Graphics/UI/statuses.png" also contains icons for being fainted and for
#       having Pokérus, in that order, at the bottom of the graphic.
#       "Graphics/UI/Battle/icon_statuses.png" also contains an icon for bad
#       poisoning (toxic), at the bottom of the graphic.
#       Both graphics automatically handle varying numbers of defined statuses,
#       as long as their extra icons remain at the bottom of them.
module GameData
  class Status
    attr_reader :id
    attr_reader :real_name
    attr_reader :animation
    attr_reader :icon_position   # Where this status's icon is within statuses.png

    DATA = {}

    extend ClassMethodsSymbols
    include InstanceMethods

    def self.load; end
    def self.save; end

    def initialize(hash)
      @id            = hash[:id]
      @real_name     = hash[:name]          || "Sin nombre"
      @animation     = hash[:animation]
      @icon_position = hash[:icon_position] || 0
    end

    # @return [String] the translated name of this status condition
    def name
      return _INTL(@real_name)
    end
  end
end

#===============================================================================

GameData::Status.register({
  :id            => :NONE,
  :name          => _INTL("Ninguno")
})

GameData::Status.register({
  :id            => :SLEEP,
  :name          => _INTL("Dormido"),
  :animation     => "Sleep",
  :icon_position => 0
})

GameData::Status.register({
  :id            => :POISON,
  :name          => _INTL("Envenenado"),
  :animation     => "Poison",
  :icon_position => 1
})

GameData::Status.register({
  :id            => :BURN,
  :name          => _INTL("Quemado"),
  :animation     => "Burn",
  :icon_position => 2
})

GameData::Status.register({
  :id            => :PARALYSIS,
  :name          => _INTL("Paralizado"),
  :animation     => "Paralysis",
  :icon_position => 3
})

if !Settings::FREEZE_EFFECTS_CAUSE_FROSTBITE
  GameData::Status.register({
    :id            => :FROZEN,
    :name          => _INTL("Congelado"),
    :animation     => "Frozen",
    :icon_position => 4
  })
else
  GameData::Status.register({
    :id            => :FROSTBITE,
    :name          => _INTL("Congelado"),
    :animation     => "Frozen",
    :icon_position => 4
  })
end
