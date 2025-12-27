#===============================================================================
# Plugin: [Gen9] Evolution Methods
# Creado por: Tu Nombre
#===============================================================================
# Este plugin agrupa toda la lógica necesaria para las evoluciones de la Gen 9.
# - Añade el contador de evolución a la clase Pokemon.
# - Implementa la lógica para contar pasos (Pawmot, Brambleghast, Rabsca).
# - Implementa la lógica para contar el uso de movimientos (Annihilape, Wyrdeer, Overqwil).
# - Implementa la lógica para contar el daño de retroceso (Basculegion).
# - Modifica la descripción en la Pokédex para mostrar los detalles correctamente.
#===============================================================================

#-------------------------------------------------------------------------------
# FIX: Parche para corregir el error "undefined method `empty'" en MUI Pokedex
#-------------------------------------------------------------------------------
class Array
  def empty; empty?; end
end

# #-------------------------------------------------------------------------------
# # FIX: Parche para corregir el error "undefined method `width' for nil:NilClass"
# #-------------------------------------------------------------------------------
# target_class = nil
# [Battle::Scene::Animation, (defined?(Battle::Scene::BaseAnimation) ? Battle::Scene::BaseAnimation : nil)].compact.each do |klass|
#   if klass.method_defined?(:ballTracksHand) || klass.private_method_defined?(:ballTracksHand)
#     target_class = klass
#     break
#   end
# end

# if target_class
#   target_class.class_eval do
#     unless method_defined?(:__dbk_crash_fix_ballTracksHand)
#       alias_method :__dbk_crash_fix_ballTracksHand, :ballTracksHand
#       def ballTracksHand(ball, trainer, *args)
#         trainer.bitmap = Bitmap.new(1, 1) if trainer && trainer.respond_to?(:bitmap) && trainer.bitmap.nil?
#         __dbk_crash_fix_ballTracksHand(ball, trainer, *args)
#       end
#     end
#   end
# end

# #-------------------------------------------------------------------------------
# # FIX: Parche para corregir el error "uninitialized constant Battle::AI::GEN_9_BASE_ABILITY_RATINGS"
# #-------------------------------------------------------------------------------
class Battle::AI
  if !defined?(GEN_9_BASE_ABILITY_RATINGS)
    GEN_9_BASE_ABILITY_RATINGS = Hash.new(0)
  elsif GEN_9_BASE_ABILITY_RATINGS.is_a?(Hash) && GEN_9_BASE_ABILITY_RATINGS.default.nil?
    GEN_9_BASE_ABILITY_RATINGS.default = 0
  end

  if !defined?(GEN_9_BASE_ITEM_RATINGS)
    GEN_9_BASE_ITEM_RATINGS = Hash.new(0)
  elsif GEN_9_BASE_ITEM_RATINGS.is_a?(Hash) && GEN_9_BASE_ITEM_RATINGS.default.nil?
    GEN_9_BASE_ITEM_RATINGS.default = 0
  end
end

# #-------------------------------------------------------------------------------
# # FIX: Parche para corregir ArgumentError en triggerCriticalCalcFromUser
# #      (given 4, expected 5) causado por conflictos entre DBK y otros plugins.
# #-------------------------------------------------------------------------------
# module Battle::AbilityEffects
#   class << self
#     unless method_defined?(:__dbk_fix_triggerCriticalCalcFromUser)
#       alias_method :__dbk_fix_triggerCriticalCalcFromUser, :triggerCriticalCalcFromUser
#       def triggerCriticalCalcFromUser(user, target, move, crit_stage, *args)
#         args.empty? ? __dbk_fix_triggerCriticalCalcFromUser(user, target, move, crit_stage, nil) : __dbk_fix_triggerCriticalCalcFromUser(user, target, move, crit_stage, *args)
#       end
#     end
#   end
# end

#-------------------------------------------------------------------------------
# 1. Extensión de la clase Pokemon para añadir el contador de evolución
#-------------------------------------------------------------------------------
class Pokemon
  attr_writer :evolution_counter

  def evolution_counter
    @evolution_counter ||= 0
  end
end

#-------------------------------------------------------------------------------
# 2. Lógica para evoluciones por pasos (Estilo "Let's Go")
#-------------------------------------------------------------------------------
EventHandlers.add(:on_player_step_taken, :evolution_counter_walking,
  proc {
    next if !$player || !$player.party
    pkmn = $player.first_able_pokemon
    next if !pkmn
    if [:BRAMBLIN, :PAWMO, :RELLOR].include?(pkmn.species)
      pkmn.evolution_counter += 1
    end
  }
)

#-------------------------------------------------------------------------------
# 3. Lógica para contar el uso de movimientos específicos
#-------------------------------------------------------------------------------
class Battle::Move
  alias_method :_gen9_evo_pbEndOfMoveUsageEffect, :pbEndOfMoveUsageEffect
  def pbEndOfMoveUsageEffect(user, targets, numHits, switchedBattlers)
    _gen9_evo_pbEndOfMoveUsageEffect(user, targets, numHits, switchedBattlers)
    return if user.fainted? || numHits == 0
    if user.isSpecies?(:PRIMEAPE) && @id == :RAGEFIST
      user.pokemon.evolution_counter += 1
    elsif user.isSpecies?(:STANTLER) && @id == :PSYSHIELDBASH
      user.pokemon.evolution_counter += 1
    elsif user.isSpecies?(:QWILFISH) && user.form == 1 && @id == :BARBBARRAGE
      user.pokemon.evolution_counter += 1
    end
  end
end

#-------------------------------------------------------------------------------
# 4. Lógica para contar el daño de retroceso (Basculegion)
#-------------------------------------------------------------------------------
class Battle::Move::RecoilMove
  def pbEffectAfterAllHits(user, target)
    return if target.damageState.unaffected
    return if !user.takesIndirectDamage?
    return if user.hasActiveAbility?(:ROCKHEAD)
    amt = pbRecoilDamage(user, target)
    amt = 1 if amt < 1
    if user.pokemon.isSpecies?(:BASCULIN) && [2, 3].include?(user.pokemon.form)
      user.pokemon.evolution_counter += amt
    end
    user.pbReduceHP(amt, false)
    @battle.pbDisplay(_INTL("¡{1} también se ha hecho daño!", user.pbThis))
    user.pbItemHPHealCheck
  end
end

class Battle::Move::Struggle
  def pbEffectAfterAllHits(user, target)
    return if target.damageState.unaffected
    amt = (user.totalhp / 4.0).round
    if user.pokemon.isSpecies?(:BASCULIN) && [2, 3].include?(user.pokemon.form)
      user.pokemon.evolution_counter += amt
    end
    user.pbReduceHP(amt, false)
    @battle.pbDisplay(_INTL("¡{1} también se ha hecho daño!", user.pbThis))
    user.pbItemHPHealCheck
  end
end

#-------------------------------------------------------------------------------
# 5. Lógica para mostrar la descripción correcta en la Pokédex
#    Depende del plugin "[MUI] Pokedex Data Page".
#-------------------------------------------------------------------------------
if PluginManager.installed?("[MUI] Pokedex Data Page")
  class GameData::Evolution
    def description(species, evo, param = nil, full = true, form = false, c = [])
      # Determines the species name.
      if GameData::Species.exists?(species)
        prefix = ""
        if @id.to_s.downcase.include?("female")
          prefix = " siendo hembra"
        elsif @id.to_s.downcase.include?("male")
          prefix = " siendo macho"
        end
        form = false if evo == :MOTHIM
        species_data = GameData::Species.get(species)
        form_name = species_data.form_name
        if form && form_name && !form_name.include?(species_data.name)
          full_name = _INTL("{2} {3}{1}", prefix, species_data.name, species_data.form_name)
        else
          full_name = _INTL("{2}{1}", prefix, species_data.name)
        end
      else
        full_name = _INTL("????")
      end
      full_name = c[1] + full_name + c[0] if !c.empty?
      # Determines the parameter name.
      case param
      when Symbol
        case @parameter
        when :Move    then par = GameData::Move.get(param).name
        when :Type    then par = GameData::Type.get(param).name
        when :Species then par = GameData::Species.get(param).name
        when :Item
          par  = GameData::Item.get(param).portion_name
          par2 = GameData::Item.get(param).portion_name_plural
        end
        prefix = ""
        if [:Type, :Item, :Species].include?(@parameter)
          prefix = ' '
        end
        param = c[2] + par + c[0] if !c.empty?
        param_name = _INTL("{1}{2}", prefix, param)
        param = c[2] + par2 + c[0] if !c.empty? && par2
        param_name2 = _INTL("{1}", param)
      when Integer
        case @id
        when :Region
          param_name = GameData::TownMap.get(param).name
        when :Location
          param_name = GameData::MapMetadata.get(param).name		  
        when :LevelDarkInParty
          param_name = GameData::Type.get(:DARK).name
        when :AttackGreater, :DefenseGreater, :AtkDefEqual
          param_name = GameData::Stat.get(:ATTACK).name
          param_name2 = GameData::Stat.get(:DEFENSE).name
        when :Counter
          if [:ANNIHILAPE, :WYRDEER, :OVERQWIL].include?(evo)
            case evo
            when :ANNIHILAPE then move_id = :RAGEFIST
            when :WYRDEER    then move_id = :PSYSHIELDBASH
            when :OVERQWIL   then move_id = :BARBBARRAGE
            end
            param_name = (move_id) ? GameData::Move.get(move_id).name : "Movimiento Especial"
            param_name2 = param.to_s
          else # Para caminar o por retroceso
            param_name = param.to_s
            param_name2 = nil
          end
        end
        if param_name
          param_name = c[2] + param_name + c[0] if !c.empty?
          param_name2 = c[2] + param_name2 + c[0] if param_name2 && !c.empty?
        else
          param_name = param.to_s
        end
      else
        case param
        when "  "
          location = (c.empty?) ? "Roca Musgosa" : c[2] + "Roca Musgosa" + c[0]
          param_name = _INTL("cerca de una {1}", location)
        when "IceRock"
          location = (c.empty?) ? "Roca Helada" : c[2] + "Roca Helada" + c[0]
          param_name = _INTL("cerca de una {1}", location)
        when "Magnetic"
          location = (c.empty?) ? "Área Magnética" : c[2] + "Área Magnética" + c[0]
          param_name = _INTL("en un {1}", location)
        else
          location = (c.empty?) ? "Área Especial" : c[2] + "Área Especial" + c[0]
          param_name = _INTL("En un {1}", location)
        end
      end
      # Determines the first portion of the description based on proc type.
      if @event_proc
        desc = (full) ? "Tiene #{full_name}" : "O" 
        desc = _INTL("{1} lanza un evento especial", desc)
      elsif @use_item_proc
        desc = (full) ? "Usando #{param_name} en #{full_name} " : "Usar #{param_name}"
      elsif @on_trade_proc
        desc = (full) ? _INTL("Intercambio {1}", full_name) : _INTL("Intercambio")
      elsif @after_battle_proc
        desc = (full) ? "Tiene #{full_name}" : ""
        desc = _INTL("{1} finaliza una batalla", desc)
      elsif @level_up_proc
        if @any_level_up
          desc = (full) ? _INTL("Subir de nivel a {1}", full_name) : _INTL("Nivel")
        else
          desc = (full) ? "Subir a #{full_name}" : "O"
          desc = _INTL("{1} al nivel {2}", desc, param)
        end
      elsif @id == :Shedinja
        desc = (full) ? "#{full_name} evoluciona" : "evolución"
        desc = _INTL("Puede dejarse en una ranura vacía del equipo después de {1}", desc)
      else
        desc = (full) ? "#{full_name} evoluciona" : "O"
        desc = _INTL("{1} a través de un método desconocido", desc)
      end
      # Determines the full description by combining method-specific details.
      temp_desc = @description
      if @id == :Counter
        case evo
        when :ANNIHILAPE, :WYRDEER, :OVERQWIL
          temp_desc = _INTL("tras usar el movimiento {1} {2} veces")
        when :BRAMBLEGHAST, :PAWMOT, :RABSCA
          temp_desc = _INTL("tras dar {1} pasos")
        when :BASCULEGION
          temp_desc = _INTL("tras perder al menos {1} PS por daño de retroceso")
        end
      end
      if !nil_or_empty?(temp_desc)
        desc2 = _INTL("#{temp_desc}", param_name, param_name2)
        full_desc = _INTL("{1} {2}.", desc, desc2)
      else
        full_desc = _INTL("{1}.", desc)
      end
      return full_desc
    end
  end
  
end

# FIX: Asegurar que Battle#canSwitch esté definido para evitar NoMethodError
class Battle
  def canSwitch
    return @rules["canSwitch"].nil? ? true : @rules["canSwitch"]
  end
end
