# Depredador
Battle::AbilityEffects::OnBattlerFainting.add(:PREDATOR,
  proc { |ability, battler, fainted, battle|
  PBDebug.log("[Ability triggered] #{battler.pbThis}'s #{battler.abilityName}")
  battle.pbShowAbilitySplash(battler, true)
  battler.pbRecoverHP(battler.totalhp / 4)
  battle.pbDisplay(_INTL("Los PS de {1} han sido restaurados.", battler.pbThis))
  battle.pbHideAbilitySplash(battler)
  }
)

# Tino Mortal
Battle::AbilityEffects::DamageCalcFromUser.add(:FATALPRECISION,
  proc { |ability, user, target, move, mults, power, type|
    mults[:attack_multiplier] *= 1.2 if Effectiveness.super_effective?(target.damageState.typeMod)
  }
)
