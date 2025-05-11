#===============================================================================
# Golden form differences
#===============================================================================

MultipleForms.register(:HEATMOR, {
  "getGoldenForm" => proc { |pkmn|
    next 1 if pkmn.hasItem?(:GOLDENSTONE)
    next
  }
})
