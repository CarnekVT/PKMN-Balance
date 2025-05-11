class Pokemon
  attr_accessor :arcane_awake
end

class PokemonEvolutionScene
  def pbEvolutionSuccess
    $stats.evolution_count += 1
    # Play cry of evolved species
    cry_time = GameData::Species.cry_length(@newspecies, @pokemon.form)
    Pokemon.play_cry(@newspecies, @pokemon.form)
    timer_start = System.uptime
    loop do
      Graphics.update
      pbUpdate
      break if System.uptime - timer_start >= cry_time
    end
    pbBGMStop
    # Success jingle/message
    pbMEPlay('Evolution success')
    newspeciesname = GameData::Species.get(@newspecies).name
    pbMessageDisplay(
      @sprites['msgwindow'],
      "\\se[]" +
        _INTL(
          '¡Enhorabuena! ¡Tu {1} evolucionó en {2}!',
          @pokemon.name,
          newspeciesname
        ) + "\\wt[80]"
    ) { pbUpdate }
    @sprites['msgwindow'].text = ''
    # Check for consumed item and check if Pokémon should be duplicated
    pbEvolutionMethodAfterEvolution
    # Modify Pokémon to make it evolved
    was_fainted = @pokemon.fainted?
    @pokemon.species = @newspecies
    @pokemon.hp = 0 if was_fainted
    @pokemon.calc_stats
    @pokemon.ready_to_evolve = false
    if @pokemon.arcane_awake
      new_ability = ARCANE_ABILITIES_LIST[@newspecies]
      @pokemon.ability = new_ability
    end
    # See and own evolved species
    was_owned = $player.owned?(@newspecies)
    $player.pokedex.register(@pokemon)
    $player.pokedex.set_owned(@newspecies)
    moves_to_learn = []
    movelist = @pokemon.getMoveList
    movelist.each do |i|
      next if i[0] != 0 && i[0] != @pokemon.level # 0 is "learn upon evolution"
      moves_to_learn.push(i[1])
    end
    # Show Pokédex entry for new species if it hasn't been owned before
    if Settings::SHOW_NEW_SPECIES_POKEDEX_ENTRY_MORE_OFTEN && !was_owned &&
         $player.has_pokedex &&
         $player.pokedex.species_in_unlocked_dex?(@pokemon.species)
      pbMessageDisplay(
        @sprites['msgwindow'],
        _INTL('Los datos de {1} se han añadido a la Pokédex.', newspeciesname)
      ) { pbUpdate }
      $player.pokedex.register_last_seen(@pokemon)
      pbFadeOutIn do
        scene = PokemonPokedexInfo_Scene.new
        screen = PokemonPokedexInfoScreen.new(scene)
        screen.pbDexEntry(@pokemon.species)
        @sprites['msgwindow'].text = '' if moves_to_learn.length > 0
        pbEndScreen(false) if moves_to_learn.length == 0
      end
    end
    # Learn moves upon evolution for evolved species
    moves_to_learn.each do |move|
      pbLearnMove(@pokemon, move, true) { pbUpdate }
    end
  end
end
