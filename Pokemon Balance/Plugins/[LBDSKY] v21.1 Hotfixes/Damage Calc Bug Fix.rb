#===============================================================================
# Fixed TypeError: nil can't be coerced into Integer in crit_stage_bonuses
# when user.effects[PBEffects::FocusEnergy] is nil.
#===============================================================================
class Battle::Move
  def crit_stage_bonuses(user)
    bonus = 0
    bonus += critical_hit_bonus
    bonus += (user.effects[PBEffects::FocusEnergy] || 0)
    bonus += 1 if @id == :SPACIALREND && user.isSpecies?(:PALKIA) && user.form == 1
    bonus += 1 if user.inHyperMode? && @type == :SHADOW
    return bonus
  end
end