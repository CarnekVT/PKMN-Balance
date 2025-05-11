#=============================================================
# GameData Species Expansion
# Todo este cacho de codigo es para poder agregarle el parametro
# GoldenForm a las Species (PBS/Pokemon.txt)
#=============================================================
module GameData
  class Species
    attr_reader :golden_form

    Species.singleton_class.alias_method :golden_schema, :schema
    def self.schema(compiling_forms = false)
      ret = self.golden_schema(compiling_forms)
      ret["GoldenForm"] = [:golden_form, "u"]
      return ret
    end

    alias golden_initialize initialize
    def initialize(hash)
      golden_initialize(hash)
      @golden_form = hash[:golden_form]
    end
  end
end

#=============================================================
# Pokemon and Battler utils
# Esta seccion es para poder cambiar la forma a la forma
# Dorada de forma rapida, facil, logica y organizada
#=============================================================
class Pokemon
  attr_accessor :goldenState
  attr_accessor :preGoldenForm

  def getGoldenForm
    return GameData::Species.get(@species).golden_form
  end

  def makeGolden
    @goldenState = true
    goldenForm = self.getGoldenForm
    @preGoldenForm = self.form
    self.form = goldenForm if goldenForm
  end

  def makeUnGolden
    self.form = @preGoldenForm if @preGoldenForm
    @goldenState = false
    @preGoldenForm = nil
  end

  def hasGoldenForm?
    echoln self.getGoldenForm
    return !self.getGoldenForm.nil?
  end

  def isOnGoldenForm?
    return self.getGoldenForm == self.form
  end
end

class Battle::Battler
  def hasGoldenForm?
    @pokemon.hasGoldenForm?
  end

  def isOnGoldenForm?
    @pokemon.isOnGoldenForm?
  end
end

#=============================================================
# On End Battle
# Esto es para asegurarme de restaurar a los Pokemon a su forma
# original
#=============================================================
EventHandlers.add(
  :on_end_battle,
  :un_golden_form,
  proc { |decision, canLose| $player.party.each { |pkmn| pkmn.makeUnGolden } }
)
