ItemHandlers::UseOnPokemon.add(:AWAKENING, proc { |item, qty, pkmn, scene|
  if pkmn.fainted? || ![:SLEEP, :DROWSY].include?(pkmn.status)
    scene.pbDisplay(_INTL("No tendría ningún efecto."))
    next false
  end
  pbSEPlay("Use item in party")
  pkmn.heal_status
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1} se despertó.", pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.copy(:AWAKENING, :CHESTOBERRY, :BLUEFLUTE, :POKEFLUTE)

ItemHandlers::CanUseInBattle.add(:AWAKENING, proc { |item, pokemon, battler, move, firstAction, battle, scene, showMessages|
  next pbBattleItemCanCureStatus?(:SLEEP, pokemon, scene, showMessages) ||
       pbBattleItemCanCureStatus?(:DROWSY, pokemon, scene, showMessages)
})

ItemHandlers::CanUseInBattle.copy(:AWAKENING, :CHESTOBERRY)

ItemHandlers::CanUseInBattle.add(:BLUEFLUTE, proc { |item, pokemon, battler, move, firstAction, battle, scene, showMessages|
  if battler&.hasActiveAbility?(:SOUNDPROOF)
    scene.pbDisplay(_INTL("No tendría ningún efecto.")) if showMessages
    next false
  end
  next pbBattleItemCanCureStatus?(:SLEEP, pokemon, scene, showMessages) ||
       pbBattleItemCanCureStatus?(:DROWSY, pokemon, scene, showMessages)
})

ItemHandlers::BattleUseOnPokemon.add(:AWAKENING, proc { |item, pokemon, battler, choices, scene|
  pokemon.heal_status
  battler&.pbCureStatus(false)
  name = (battler) ? battler.pbThis : pokemon.name
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1} se despertó.", name))
})

ItemHandlers::BattleUseOnPokemon.copy(:AWAKENING, :CHESTOBERRY, :BLUEFLUTE)

ItemHandlers::CanUseInBattle.add(:POKEFLUTE, proc { |item, pokemon, battler, move, firstAction, battle, scene, showMessages|
  if battle.allBattlers.none? { |b| [:SLEEP, :DROWSY].include?(b.status) && !b.hasActiveAbility?(:SOUNDPROOF) }
    scene.pbDisplay(_INTL("No tendría ningún efecto.")) if showMessages
    next false
  end
  next true
})

ItemHandlers::UseInBattle.add(:POKEFLUTE, proc { |item, battler, battle|
  battle.allBattlers.each do |b|
    b.pbCureStatus(false) if [:SLEEP, :DROWSY].include?(b.status) && !b.hasActiveAbility?(:SOUNDPROOF)
  end
  battle.pbDisplay(_INTL("¡Todos los Pokémon se despertaron con la melodía!"))
})

Battle::ItemEffects::StatusCure.add(:LUMBERRY,
  proc { |item, battler, battle, forced|
    next false if !forced && !battler.canConsumeBerry?
    next false if battler.status == :NONE &&
                  battler.effects[PBEffects::Confusion] == 0
    itemName = GameData::Item.get(item).name
    PBDebug.log("[Item triggered] #{battler.pbThis}'s #{itemName}") if forced
    battle.pbCommonAnimation("EatBerry", battler) if !forced
    oldStatus = battler.status
    oldConfusion = (battler.effects[PBEffects::Confusion] > 0)
    battler.pbCureStatus(forced)
    battler.pbCureConfusion
    if forced
      battle.pbDisplay(_INTL("¡{1} ya no está confuso!", battler.pbThis)) if oldConfusion
    else
      case oldStatus
      when :SLEEP
        battle.pbDisplay(_INTL("¡{1} se ha despertado con {2}!", battler.pbThis, itemName))
      when :POISON
        battle.pbDisplay(_INTL("¡{1} se ha curado del envenienmiento con {2}!", battler.pbThis, itemName))
      when :BURN
        battle.pbDisplay(_INTL("¡{1} se ha curado de las quemaduras con {2}!", battler.pbThis, itemName))
      when :PARALYSIS
        battle.pbDisplay(_INTL("¡{1} se ha curado de la parálisis con {2}!", battler.pbThis, itemName))
      when :FROZEN
        battle.pbDisplay(_INTL("¡{1} se ha descongelado con {2}!", battler.pbThis, itemName))
      when :FROSTBITE
        battle.pbDisplay(_INTL("¡{1} se ha curado de la helada con {2}!", battler.pbThis, itemName))
      when :DROWSY
        battle.pbDisplay(_INTL("¡{1} se ha despertado con {2}!", battler.pbThis, itemName))
      end
      if oldConfusion
        battle.pbDisplay(_INTL("¡{1} ya no está confuso gracias a {2}!", battler.pbThis, itemName))
      end
    end
    next true
  }
)

Battle::ItemEffects::StatusCure.add(:CHESTOBERRY,
  proc { |item, battler, battle, forced|
    next false if !forced && !battler.canConsumeBerry?
    next false if ![:SLEEP, :DROWSY].include?(battler.status)
    itemName = GameData::Item.get(item).name
    PBDebug.log("[Item triggered] #{battler.pbThis}'s #{itemName}") if forced
    battle.pbCommonAnimation("EatBerry", battler) if !forced
    battler.pbCureStatus(forced)
    battle.pbDisplay(_INTL("¡{1} se ha despertado con {2}!", battler.pbThis, itemName)) if !forced
    next true
  }
)