ARCANE_ABILITIES_LIST = {
  BULBASAUR: :THICKFAT,
  IVYSAUR:   :THICKFAT,
  VENUSAUR:  :THICKFAT,
  DRAGONITE: :SPEEDBOOST,
  BLASTOISE: :SPEEDBOOST
}

ItemHandlers::UseOnPokemon.add(
  :ARCANETEA,
  proc do |item, qty, pkmn, scene|
    new_ability = ARCANE_ABILITIES_LIST[pkmn.species]
    if pkmn.arcane_awake && pkmn.ability == new_ability
      pbMessage(
        _INTL('¡{1} ya está en sintonía con su Habilidad Arcana.', pkmn.name)
      )
      next false
    end
    if new_ability.nil?
      pbMessage(_INTL('No tendría ningún efecto.'))
      next false
    end
    pkmn.ability = new_ability
    pkmn.arcane_awake = true
    pbMessage(
      _INTL(
        '¡{1} siente el Té Arcano fluyendo! ¡Su Habilidad ahora es {2}!',
        pkmn.name,
        GameData::Ability.get(new_ability).name
      )
    )
    next true
  end
)
