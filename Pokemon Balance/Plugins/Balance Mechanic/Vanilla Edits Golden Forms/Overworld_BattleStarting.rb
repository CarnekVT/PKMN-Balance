  def after_battle(outcome, can_lose)
    $player.party.each do |pkmn|
      pkmn.statusCount = 0 if pkmn.status == :POISON   # Bad poison becomes regular
      pkmn.makeUnmega
      pkmn.makeUnprimal
      pkmn.makeUngolden
    end
    if $PokemonGlobal.partner
      $player.heal_party
      $PokemonGlobal.partner[3].each do |pkmn|
        pkmn.heal
        pkmn.makeUnmega
        pkmn.makeUnprimal
        pkmn.makeUngolden
      end
    end
    if [2, 5].include?(outcome) && can_lose   # if loss or draw
      $player.party.each { |pkmn| pkmn.heal }
      timer_start = System.uptime
      until System.uptime - timer_start >= 0.25
        Graphics.update
      end
    end
    EventHandlers.trigger(:on_end_battle, outcome, can_lose)
    $game_player.straighten
  end
