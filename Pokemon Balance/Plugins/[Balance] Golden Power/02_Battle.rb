class Battle
  def pbHasGoldenRing?(idxBattler)
    if pbOwnedByPlayer?(idxBattler)
      return true if $bag.has?(:GOLDENSRING)
    else
      trainer_items = pbGetOwnerItems(idxBattler)
      return true if trainer_items.include?(:GOLDENSRING)
    end
    return false
  end

  def pbCanGoldenForm?(idxBattler, item = :GOLDENSTONE)
    if !@battlers[idxBattler].hasGoldenForm? && item == :GOLDENSTONE
      return false
    end
    return false if !pbHasGoldenRing?(idxBattler)

    side = @battlers[idxBattler].idxOwnSide
    owner = pbGetOwnerIndexFromBattlerIndex(idxBattler)
    @goldenForm ||= {}

    echoln "#{side}_#{owner} -> #{@goldenForm["#{side}_#{owner}"]} (#{@battlers[idxBattler].name})"
    return @goldenForm["#{side}_#{owner}"].nil?
  end

  def pbStartGoldenForm(idxBattler)
    return if !pbCanGoldenForm?(idxBattler)
    battler = @battlers[idxBattler]
    old_ability = battler.ability_id

    self.pbDisplay(
      _INTL(
        "¡{1} supero sus limites hasta alcanzar su forma dorada!",
        battler.pbThis
      )
    )
    pbCommonAnimation("MegaEvolution", battler)
    battler.pokemon.makeGolden
    battler.form = battler.pokemon.form
    battler.pbUpdate(true)
    @scene.pbChangePokemon(battler, battler.pokemon)
    @scene.pbRefreshOne(idxBattler)
    pbCommonAnimation("MegaEvolution2", battler)
    pbRegisterGoldenForm(idxBattler)

    battler.pbOnLosingAbility(old_ability)
    battler.pbTriggerAbilityOnGainingIt
    pbCalculatePriority(false, [idxBattler])
  end

  def pbRegisterGoldenForm(idxBattler)
    side = @battlers[idxBattler].idxOwnSide
    owner = pbGetOwnerIndexFromBattlerIndex(idxBattler)
    @goldenForm["#{side}_#{owner}"] = true
  end
end

#=============================================================
#region ItemRegion
#=============================================================
#-------------------------------------------------------------
# GOLDENFRAGMENT
#-------------------------------------------------------------
Battle::ItemEffects::OnSwitchIn.add(
  :GOLDENFRAGMENT,
  proc do |item, battler, battle|
    idxBattler = battler.index
    if battle.pbCanGoldenForm?(idxBattler, :GOLDENFRAGMENT)
      battle.pbDisplay(
        _INTL("¡{1} se va fortaleciendo por un aura dorada!", battler.pbThis)
      )
      battler.pokemon.goldenState = true
      battle.pbRegisterGoldenForm(battler.index)
    end
  end
)

Battle::ItemEffects::EndOfRoundEffect.add(
  :GOLDENFRAGMENT,
  proc do |item, battler, battle|
    if battler.pokemon.goldenState
      base_stats = GameData::Species.get(battler.pokemon.species).base_stats
      biggerStat = :ATTACK
      actualStatValue = 0
      GameData::Stat.each_main do |s|
        biggerStat = s.id if base_stats[s.id] > actualStatValue
        actualStatValue = base_stats[s.id]
      end
      battler.pbRaiseStatStageByCause(biggerStat, 2, battler, "Golden State")
      totalLoss = battler.pbReduceHP(battler.totalhp / 20)
      battle.pbDisplay(
        _INTL(
          "¡{1} ha perdido {2} PS debido a su forma dorada!",
          battler.pbThis,
          totalLoss
        )
      )
    end
  end
)

#-------------------------------------------------------------
# GOLDENSTONE
#-------------------------------------------------------------
Battle::ItemEffects::OnSwitchIn.add(
  :GOLDENSTONE,
  proc do |item, battler, battle|
    idxBattler = battler.index
    battle.pbStartGoldenForm(idxBattler)
  end
)

Battle::ItemEffects::EndOfRoundEffect.add(
  :GOLDENSTONE,
  proc do |item, battler, battle|
    if battler.isOnGoldenForm?
      totalLoss = battler.pbReduceHP(battler.totalhp / 10)
      battle.pbDisplay(
        _INTL(
          "¡{1} ha perdido {2} PS debido a su forma dorada!",
          battler.pbThis,
          totalLoss
        )
      )
    end
  end
)
#=============================================================
#endregion
#=============================================================
