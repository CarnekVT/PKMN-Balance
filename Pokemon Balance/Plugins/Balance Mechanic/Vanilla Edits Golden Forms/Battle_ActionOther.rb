  #=============================================================================
  # Goldening a battler
  #=============================================================================
  def pbGoldenReversion(idxBattler)
    battler = @battlers[idxBattler]
    return if !battler || !battler.pokemon || battler.fainted?
    return if !battler.hasGolden? || battler.golden?
    battler.pokemon.makeGolden
    battler.form = battler.pokemon.form
    battler.pbUpdate(true)
    @scene.pbChangePokemon(battler, battler.pokemon)
    @scene.pbRefreshOne(idxBattler)
    pbDisplay(_INTL("¡{1} superó sus límites hasta alcanzar su época dorada!", battler.pbThis))
  end