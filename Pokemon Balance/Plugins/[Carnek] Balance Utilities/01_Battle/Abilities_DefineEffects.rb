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

# Insomnio con Somnoliento
Battle::AbilityEffects::StatusImmunity.add(:INSOMNIA,
  proc { |ability, battler, status|
    next true if status == :SLEEP || status == :DROWSY
  }
)

Battle::AbilityEffects::StatusImmunity.copy(:INSOMNIA, :SWEETVEIL, :VITALSPIRIT)

Battle::AbilityEffects::StatusCure.add(:INSOMNIA,
  proc { |ability, battler|
    next if ![:SLEEP, :DROWSY].include?(battler.status)
    battler.battle.pbShowAbilitySplash(battler)
    battler.pbCureStatus(Battle::Scene::USE_ABILITY_SPLASH)
    if !Battle::Scene::USE_ABILITY_SPLASH
      battler.battle.pbDisplay(_INTL("¡La habilidad {2} de {1} lo despertó!", battler.pbThis, battler.abilityName))
    end
    battler.battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::StatusCure.copy(:INSOMNIA, :VITALSPIRIT)

# Alma Cura con Somnoliento

Battle::AbilityEffects::EndOfRoundHealing.add(:HEALER,
  proc { |ability, battler, battle|
    next if battle.pbRandom(100) >= 30
    battler.allAllies.each do |b|
      next if b.status == :NONE
      battle.pbShowAbilitySplash(battler)
      oldStatus = b.status
      b.pbCureStatus(Battle::Scene::USE_ABILITY_SPLASH)
      if !Battle::Scene::USE_ABILITY_SPLASH
        case oldStatus
        when :SLEEP
          battle.pbDisplay(_INTL("¡La habilidad {2} de {1} despertó a su compañero!", battler.pbThis, battler.abilityName))
        when :POISON
          battle.pbDisplay(_INTL("¡La habilidad {2} de {1} curó el envenamiento de su compañero!", battler.pbThis, battler.abilityName))
        when :BURN
          battle.pbDisplay(_INTL("¡La habilidad {2} de {1} curó la quemadura de su compañero!", battler.pbThis, battler.abilityName))
        when :PARALYSIS
          battle.pbDisplay(_INTL("¡La habilidad {2} de {1} curó la parálisis de su compañero!", battler.pbThis, battler.abilityName))
        when :FROZEN
          battle.pbDisplay(_INTL("¡La habilidad {2} de {1} descongelo a su compañero!", battler.pbThis, battler.abilityName))
        when :FROSTBITE
          battle.pbDisplay(_INTL("¡La habilidad {2} de {1} descongelo a su compañero!", battler.pbThis, battler.abilityName))
        when :DROWSY
          battle.pbDisplay(_INTL("¡La habilidad {2} de {1} despertó a su compañero!", battler.pbThis, battler.abilityName))
        end
      end
      battle.pbHideAbilitySplash(battler)
    end
  }
)

# Hidratación con Somnoliento

Battle::AbilityEffects::EndOfRoundHealing.add(:HYDRATION,
  proc { |ability, battler, battle|
    next if battler.status == :NONE
    next if ![:Rain, :HeavyRain].include?(battler.effectiveWeather)
    battle.pbShowAbilitySplash(battler)
    oldStatus = battler.status
    battler.pbCureStatus(Battle::Scene::USE_ABILITY_SPLASH)
    if !Battle::Scene::USE_ABILITY_SPLASH
      case oldStatus
      when :SLEEP
        battle.pbDisplay(_INTL("¡La habilidad {2} de {1} le despertó!", battler.pbThis, battler.abilityName))
      when :POISON
        battle.pbDisplay(_INTL("¡La habilidad {2} de {1} curó su envenamiento!", battler.pbThis, battler.abilityName))
      when :BURN
        battle.pbDisplay(_INTL("¡La habilidad {2} de {1} curó su quemadura!", battler.pbThis, battler.abilityName))
      when :PARALYSIS
        battle.pbDisplay(_INTL("¡La habilidad {2} de {1} curó su parálisis!", battler.pbThis, battler.abilityName))
      when :FROZEN
        battle.pbDisplay(_INTL("¡La habilidad {2} de {1} le descongeló!", battler.pbThis, battler.abilityName))
      when :FROSTBITE
        battle.pbDisplay(_INTL("¡La habilidad {2} de {1} le descongeló!", battler.pbThis, battler.abilityName))
      when :DROWSY
        battle.pbDisplay(_INTL("¡La habilidad {2} de {1} le despertó!", battler.pbThis, battler.abilityName))
      end
    end
    battle.pbHideAbilitySplash(battler)
  }
)

# Mudar con Somnoliento

Battle::AbilityEffects::EndOfRoundHealing.add(:SHEDSKIN,
  proc { |ability, battler, battle|
    next if battler.status == :NONE
    next unless battle.pbRandom(100) < 30
    battle.pbShowAbilitySplash(battler)
    oldStatus = battler.status
    battler.pbCureStatus(Battle::Scene::USE_ABILITY_SPLASH)
    if !Battle::Scene::USE_ABILITY_SPLASH
      case oldStatus
      when :SLEEP
        battle.pbDisplay(_INTL("¡La habilidad {2} de {1} le despertó!", battler.pbThis, battler.abilityName))
      when :POISON
        battle.pbDisplay(_INTL("¡La habilidad {2} de {1} curó su envenamiento!", battler.pbThis, battler.abilityName))
      when :BURN
        battle.pbDisplay(_INTL("¡La habilidad {2} de {1} curó su quemadura!", battler.pbThis, battler.abilityName))
      when :PARALYSIS
        battle.pbDisplay(_INTL("¡La habilidad {2} de {1} curó su parálisis!", battler.pbThis, battler.abilityName))
      when :FROZEN
        battle.pbDisplay(_INTL("¡La habilidad {2} de {1} le descongeló!", battler.pbThis, battler.abilityName))
      when :FROSTBITE
        battle.pbDisplay(_INTL("¡La habilidad {2} de {1} le descongeló!", battler.pbThis, battler.abilityName))
      when :DROWSY
        battle.pbDisplay(_INTL("¡La habilidad {2} de {1} le despertó!", battler.pbThis, battler.abilityName))
      end
    end
    battle.pbHideAbilitySplash(battler)
  }
)

# Sincroniazción con Somnoliento

Battle::AbilityEffects::OnStatusInflicted.add(:SYNCHRONIZE,
  proc { |ability, battler, user, status|
    next if !user || user.index == battler.index
    case status
    when :POISON
      if user.pbCanPoisonSynchronize?(battler)
        battler.battle.pbShowAbilitySplash(battler)
        msg = nil
        if !Battle::Scene::USE_ABILITY_SPLASH
          msg = _INTL("¡La habilidad {2} de {1} envenenó a {3}!", battler.pbThis, battler.abilityName, user.pbThis(true))
        end
        user.pbPoison(nil, msg, (battler.statusCount > 0))
        battler.battle.pbHideAbilitySplash(battler)
      end
    when :BURN
      if user.pbCanBurnSynchronize?(battler)
        battler.battle.pbShowAbilitySplash(battler)
        msg = nil
        if !Battle::Scene::USE_ABILITY_SPLASH
          msg = _INTL("¡La habilidad {2} de {1} quemó a {3}!", battler.pbThis, battler.abilityName, user.pbThis(true))
        end
        user.pbBurn(nil, msg)
        battler.battle.pbHideAbilitySplash(battler)
      end
    when :PARALYSIS
      if user.pbCanParalyzeSynchronize?(battler)
        battler.battle.pbShowAbilitySplash(battler)
        msg = nil
        if !Battle::Scene::USE_ABILITY_SPLASH
          msg = _INTL("¡La habilidad {2} de {1} paralizó a {3}! ¡Quizás no se pueda mover!",
             battler.pbThis, battler.abilityName, user.pbThis(true))
        end
        user.pbParalyze(nil, msg)
        battler.battle.pbHideAbilitySplash(battler)
      end
    when :FROSTBITE
      if user.pbCanSynchronizeStatus?(:FROZEN, battler)
        battler.battle.pbShowAbilitySplash(battler)
        msg = nil
        if !Battle::Scene::USE_ABILITY_SPLASH
          msg = _INTL("¡{2} de {1} heló a {3}!", battler.pbThis, battler.abilityName, user.pbThis(true))
        end
        user.pbFreeze(nil, msg)
        battler.battle.pbHideAbilitySplash(battler)
      end
    when :DROWSY
      if user.pbCanSynchronizeStatus?(:SLEEP, battler)
        battler.battle.pbShowAbilitySplash(battler)
        msg = nil
        if !Battle::Scene::USE_ABILITY_SPLASH
          msg = _INTL("¡{2} de {1} le causó somnolencia a {3}!",
             battler.pbThis, battler.abilityName, user.pbThis(true))
        end
        user.pbSleep(nil, msg)
        battler.battle.pbHideAbilitySplash(battler)
      end
    end
  }
)