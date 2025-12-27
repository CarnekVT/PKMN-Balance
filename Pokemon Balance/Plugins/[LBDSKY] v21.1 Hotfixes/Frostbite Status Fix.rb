#===============================================================================
# Adds id_number to Status class and FROSTBITE status if not defined.
#===============================================================================
class GameData::Status
  attr_reader :id_number

  alias __frostbite_fix__initialize initialize

  def initialize(hash)
    __frostbite_fix__initialize(hash)
    @id_number = hash[:id_number] || 0
  end
end

if !GameData::Status.exists?(:FROSTBITE)
  GameData::Status.register({
    :id            => :FROSTBITE,
    :id_number     => 4,
    :name          => _INTL("Frostbite"),
    :animation     => "Frozen",
    :icon_position => 4
  })
end

#===============================================================================
# Initialize FocusEnergy effect to 0 to prevent nil errors.
#===============================================================================
class Battle::Battler
  alias __focus_energy_init__initialize initialize

  def initialize(*args)
    __focus_energy_init__initialize(*args)
    @effects[PBEffects::FocusEnergy] ||= 0
  end
end