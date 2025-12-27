#===============================================================================
# MoveEffects_Balance.rb
# Implementación de efectos de movimientos nuevos para Pokemon Balance
#===============================================================================

# Define HoneyTerrain effect constant if it doesn't exist
module PBEffects
  HoneyTerrain = 1001 unless const_defined?(:HoneyTerrain)
end

#-------------------------------------------------------------------------------
# [CORRODE] - Corrobomba
#-------------------------------------------------------------------------------
# Poisons the target. Super effective against Steel types.
#-------------------------------------------------------------------------------
class Battle::Move::PoisonTargetSuperEffectiveAgainstSteel < Battle::Move::PoisonTarget
  def pbCalcTypeModSingle(moveType, defType, user, target)
    return Effectiveness::SUPER_EFFECTIVE_MULTIPLIER if defType == :STEEL
    return super
  end
end

#-------------------------------------------------------------------------------
# [FAIRYDANCE] - Danza Feérica
#-------------------------------------------------------------------------------
# Raises user's Sp. Atk and Speed by 1 stage.
#-------------------------------------------------------------------------------
class Battle::Move::RaiseUserSpAtkSpd1 < Battle::Move::MultiStatUpMove
  def initialize(battle, move)
    super
    @statUp = [:SPECIAL_ATTACK, 1, :SPEED, 1]
  end
end

#-------------------------------------------------------------------------------
# [POLLINATE] - Polibomba
#-------------------------------------------------------------------------------
# Lowers target's Speed by 2 stages if Honey Terrain is active.
#-------------------------------------------------------------------------------
class Battle::Move::LowerTargetSpeed2IfHoneyTerrain < Battle::Move
  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    if defined?(PBEffects::HoneyTerrain) && @battle.field.effects[PBEffects::HoneyTerrain] > 0
      if target.pbCanLowerStatStage?(:SPEED, user, self)
        target.pbLowerStatStage(:SPEED, 2, user)
      end
    end
  end
end

#-------------------------------------------------------------------------------
# [PHANTOMAMORE] - Amorío Espectral
#-------------------------------------------------------------------------------
# Lowers target's Sp. Atk by 1 stage if it is the opposite gender.
#-------------------------------------------------------------------------------
class Battle::Move::LowerTargetSpAtk1IfOppositeGender < Battle::Move
  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    return if user.gender == 2 || target.gender == 2 || user.gender == target.gender
    if target.pbCanLowerStatStage?(:SPECIAL_ATTACK, user, self)
      target.pbLowerStatStage(:SPECIAL_ATTACK, 1, user)
    end
  end
end

#-------------------------------------------------------------------------------
# [SPIRITUALSUN] - Sol Espiritual
#-------------------------------------------------------------------------------
# Damages target and has a chance to start Sun weather.
#-------------------------------------------------------------------------------
class Battle::Move::DamageTargetStartSunWeather < Battle::Move
  def pbAdditionalEffect(user, target)
    return if @battle.field.weather == :Sun || @battle.field.weather == :HarshSun
    @battle.pbStartWeather(:Sun, 5)
    @battle.pbDisplay(_INTL("¡La luz solar se ha intensificado!"))
  end
end

#-------------------------------------------------------------------------------
# [STEAMSURGE] - Rizo Vapor
#-------------------------------------------------------------------------------
# Double power in Misty Terrain.
#-------------------------------------------------------------------------------
class Battle::Move::DoublePowerInMistyTerrain < Battle::Move
  def pbBaseDamage(baseDmg, user, target)
    if @battle.field.terrain == :Misty
      baseDmg *= 2
    end
    return baseDmg
  end
end

#-------------------------------------------------------------------------------
# [DELIRIUMPASSIOND], [DELIRIUMPASSIONL] - Pasión Delirio
#-------------------------------------------------------------------------------
# Raises stats based on species at the cost of 1/3 max HP.
# Druddigon: +2 Atk, +2 Def, +1 Spd
# Lilligant: +2 SpAtk, +2 SpDef, +1 Spd
# Others: +1 All Main Stats
#-------------------------------------------------------------------------------
class Battle::Move::RaiseStatsBasedOnSpeciesLoseHP < Battle::Move
  def pbMoveFailed?(user, targets)
    if user.hp <= (user.totalhp / 3.0).floor
      @battle.pbDisplay(_INTL("¡Pero ha fallado!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbReduceHP((user.totalhp / 3.0).floor, false)
    showAnim = true
    
    if user.isSpecies?(:DRUDDIGON)
      stats = [:ATTACK, 2, :DEFENSE, 2, :SPEED, 1]
    elsif user.isSpecies?(:LILLIGANT)
      stats = [:SPECIAL_ATTACK, 2, :SPECIAL_DEFENSE, 2, :SPEED, 1]
    else
      stats = [:ATTACK, 1, :DEFENSE, 1, :SPECIAL_ATTACK, 1, :SPECIAL_DEFENSE, 1, :SPEED, 1]
    end
    
    i = 0
    while i < stats.length
      stat = stats[i]
      increment = stats[i+1]
      if user.pbCanRaiseStatStage?(stat, user, self)
        user.pbRaiseStatStage(stat, increment, user, showAnim)
        showAnim = false
      end
      i += 2
    end
  end
end

#-------------------------------------------------------------------------------
# [HONEYTERRAIN] - Campo de Miel
#-------------------------------------------------------------------------------
# Starts Honey Terrain for 5 turns.
#-------------------------------------------------------------------------------
class Battle::Move::StartHoneyTerrain < Battle::Move
  def pbMoveFailed?(user, targets)
    if defined?(PBEffects::HoneyTerrain) && @battle.field.effects[PBEffects::HoneyTerrain] > 0
      @battle.pbDisplay(_INTL("¡Pero ha fallado!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    if defined?(PBEffects::HoneyTerrain)
      @battle.field.effects[PBEffects::HoneyTerrain] = 5
      @battle.pbDisplay(_INTL("¡El terreno se ha cubierto de miel pegajosa!"))
    else
      @battle.pbDisplay(_INTL("¡Pero ha fallado! (Efecto no implementado)"))
    end
  end
end

#-------------------------------------------------------------------------------
# [LIQUIDIZE] - Liquidar
#-------------------------------------------------------------------------------
# Badly poisons the target, ignoring type immunity (Poison/Steel).
#-------------------------------------------------------------------------------
class Battle::Move::BadPoisonTargetIgnoreType < Battle::Move::BadPoisonTarget
  def pbFailsAgainstTarget?(user, target, show_message)
    if target.pbHasStatus?(:POISON)
       @battle.pbDisplay(_INTL("¡{1} ya está envenenado!", target.pbThis)) if show_message
       return true
    end
    if target.status != :NONE
       @battle.pbDisplay(_INTL("No afecta a {1}...", target.pbThis(true))) if show_message
       return true
    end
    if @battle.field.terrain == :Misty && target.affectedByTerrain?
      @battle.pbDisplay(_INTL("¡El campo de niebla ha protegido a {1}!", target.pbThis(true))) if show_message
      return true
    end
    if target.pbOwnSide.effects[PBEffects::Safeguard] > 0 && !user.hasActiveAbility?(:INFILTRATOR)
      @battle.pbDisplay(_INTL("¡{1} se ha protegido con Velo Sagrado!", target.pbThis)) if show_message
      return true
    end
    if Battle::AbilityEffects.triggerStatusImmunityNonIgnorable(target.ability, target, :POISON)
      @battle.pbDisplay(_INTL("¡No afecta a {1}...", target.pbThis(true))) if show_message
      return true
    end
    return false
  end
  
  def pbEffectAgainstTarget(user, target)
    target.pbPoison(user, nil, true)
  end
end

#-------------------------------------------------------------------------------
# [MAGICSPARKLE] - Chispa Mágica
#-------------------------------------------------------------------------------
# Lowers target's Def and Sp. Def by 1 stage if Misty Terrain is active.
#-------------------------------------------------------------------------------
class Battle::Move::LowerTargetDefSpDef1InMistyTerrain < Battle::Move
  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    if @battle.field.terrain == :Misty
      showAnim = true
      [:DEFENSE, :SPECIAL_DEFENSE].each do |stat|
        if target.pbCanLowerStatStage?(stat, user, self)
          target.pbLowerStatStage(stat, 1, user, showAnim)
          showAnim = false
        end
      end
    end
  end
end

#-------------------------------------------------------------------------------
# [FLORALTOXINE] - Toxina Floral
#-------------------------------------------------------------------------------
# Damages target and plants Leech Seed.
#-------------------------------------------------------------------------------
class Battle::Move::DamageTargetStartLeechSeed < Battle::Move
  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    return if target.effects[PBEffects::LeechSeed] >= 0
    return if target.pbHasType?(:GRASS)
    
    target.effects[PBEffects::LeechSeed] = user.index
    @battle.pbDisplay(_INTL("¡{1} fue infectado!", target.pbThis))
  end
end