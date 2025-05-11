def pbEonBattle
    setBattleRule("cannotRun")
    setBattleRule("weather", :Hail)
    setBattleRule("backdrop", "champion2")
    setBattleRule("editWildPokemon", {
      :nature  => :MODEST,
      :item    => :SOULDEW,
      :ability => :HEALER,
      :moves   => [:LIFEDEW, :REFLECT, :HELPINGHAND, :PSYCHIC]
    })
    setBattleRule("editWildPokemon2", {
      :nature  => :ADAMANT,
      :item    => :SOULDEW,
      :ability => :FRIENDGUARD,
      :moves   => [:DRAGONDANCE, :BREAKINGSWIPE, :ZENHEADBUTT, :EARTHQUAKE]
    })
    setBattleRule("midbattleScript", {
      "TargetHPLow_foe_repeat" => {
        "text_A"    => "{1} calls out to its partner with a whimpering cry!",
        "playCry"   => :Self,
        "text_B"    => [:Ally, "{1} comes to its partner's aid!"],
        "battlerHP" => [4, "{1} restored a little HP!"]
      },
      "BattlerFainted_foe" => {
        "setBattler" => :Ally,
        "text"       => "{1} looks upset by its partner's defeat...\nIt lost the will to fight!",
        "wildFlee"   => true
      }
    })
    pbRegisterPartner(:LEADER_Brock, "Brock")
    WildBattle.start(:LATIAS, 30, :LATIOS, 30)
end