#===============================================================================
# Golden Reversion.
#===============================================================================


#-------------------------------------------------------------------------------
# Game stat tracking for Golden Reversion.
#-------------------------------------------------------------------------------
class GameStats
  alias golden_initialize initialize
  def initialize
    golden_initialize
    @golden_reversion_count = 0
  end

  def golden_reversion_count
    return @golden_reversion_count || 0
  end
  
  def golden_reversion_count=(value)
    @golden_reversion_count = 0 if !@golden_reversion_count
    @golden_reversion_count = value
  end
end

#-------------------------------------------------------------------------------
# Updates to Golden Reversion battle scripts.
#-------------------------------------------------------------------------------
class Battle
  def pbGoldenReversion(idxBattler)
    battler = @battlers[idxBattler]
    return if !battler || !battler.pokemon || battler.fainted?
    return if !battler.hasGolden? || battler.golden?
    $stats.golden_reversion_count += 1 if battler.pbOwnedByPlayer?
    pbDeluxeTriggers(idxBattler, nil, "BeforeGoldenReversion", battler.species, *battler.pokemon.types)
    pbAnimateGoldenReversion(battler)
    pbDisplay(_INTL("¡{1} superó sus límites hasta alcanzar su época dorada!", battler.pbThis))
    pbDeluxeTriggers(idxBattler, nil, "AfterGoldenReversion", battler.species, *battler.pokemon.types)
  end
  
  def pbAnimateGoldenReversion(battler)
    anim = "Golden" + battler.pokemon.speciesName
    if @scene.pbCommonAnimationExists?(anim)
      pbCommonAnimation(anim, battler)
      battler.pokemon.makeGolden
      battler.form_update(true)
      pbCommonAnimation(anim + "2", battler)
    else 
      if Settings::SHOW_PRIMAL_ANIM && $PokemonSystem.battlescene == 0
        @scene.pbShowGoldenReversion(battler.index)
        battler.pokemon.makeGolden
        battler.form_update(true)
      else
        @scene.pbRevertBattlerStart(battler.index)
        battler.pokemon.makeGolden
        battler.form_update(true)
        @scene.pbRevertBattlerEnd
      end
    end
  end
end

#-------------------------------------------------------------------------------
# Used to more easily obtain Golden form data for the animation.
#-------------------------------------------------------------------------------
class Pokemon
  def getGoldenForm
    v = MultipleForms.call("getGoldenForm", self)
    return v || @form
  end
  
  def getUngoldenForm
    v = MultipleForms.call("getUngoldenForm", self)
    return v || 0
  end
end

#===============================================================================
# Battle animation for triggering Golden Reversion.
#===============================================================================
class Battle::Scene::Animation::BattlerGoldenReversion < Battle::Scene::Animation
  def initialize(sprites, viewport, idxBattler, battle)
    @idxBattler = idxBattler
    #---------------------------------------------------------------------------
    # Gets Pokemon data from battler index.
    @battle = battle
    @battler = @battle.battlers[idxBattler]
    @opposes = @battle.opposes?(idxBattler)
    @pkmn = @battler.pokemon
    @golden = [@pkmn.species, @pkmn.gender, @pkmn.getGoldenForm, @pkmn.shiny?, @pkmn.shadowPokemon?]
    @cry_file = GameData::Species.cry_filename(@golden[0], @golden[2])
    case @pkmn.species
    when :GROUDON then @bg_color = Color.new(255, 0, 0, 180)
    when :KYOGRE  then @bg_color = Color.new(0, 0, 255, 180)
    else               @bg_color = Color.new(240, 188, 66, 180)
    end
    #---------------------------------------------------------------------------
    # Gets background and animation data.
    @path = Settings::DELUXE_GRAPHICS_PATH
    backdropFilename, baseFilename = @battle.pbGetBattlefieldFiles
    @bg_file   = "Graphics/Battlebacks/" + backdropFilename + "_bg"
    @base_file = "Graphics/Battlebacks/" + baseFilename + "_base1"
    super(sprites, viewport)
  end
  
  #-----------------------------------------------------------------------------
  # Plays the animation.
  #-----------------------------------------------------------------------------
  def createProcesses
    delay = 0
    center_x, center_y = Graphics.width / 2, Graphics.height / 2
    #---------------------------------------------------------------------------
    # Sets up background.
    bgData = dxSetBackdrop(@path + "Golden/bg", @bg_file, delay)
    picBG, sprBG = bgData[0], bgData[1]
    #---------------------------------------------------------------------------
    # Sets up bases.
    baseData = dxSetBases(@path + "Golden/base", @base_file, delay, center_x, center_y)
    arrBASES = baseData[0]
    #---------------------------------------------------------------------------
    # Sets up overlay.
    overlayData = dxSetOverlay(@path + "burst", delay)
    picOVERLAY, sprOVERLAY = overlayData[0], overlayData[1]
    #---------------------------------------------------------------------------
    # Sets up battler.
    pokeData = dxSetPokemon(@pkmn, delay, !@opposes)
    picPOKE, sprPOKE = pokeData[0], pokeData[1]
    #---------------------------------------------------------------------------
    # Animation objects.
    orbData = dxSetSprite(@path + "Golden/orb_" + @pkmn.species.to_s, delay, center_x, center_y, false, 0, 0)
    picORB, sprORB = orbData[0], orbData[1]
    shineData = dxSetSprite(@path + "shine", delay, center_x, center_y)
    picSHINE, sprSHINE = shineData[0], shineData[1]
    #---------------------------------------------------------------------------
    # Sets up Golden Pokemon.
    arrPOKE = dxSetPokemonWithOutline(@golden, delay, !@opposes)
    arrPOKE.last[0].setColor(delay, Color.white)
    #---------------------------------------------------------------------------
    # Sets up Golden icon.
    iconData = dxSetSprite(@path + "Golden/icon_" + @pkmn.species.to_s, delay, center_x, center_y, false, 0)
    picORB2, sprORB2 = iconData[0], iconData[1]
    #---------------------------------------------------------------------------
    # Animation objects.
    arrPARTICLES = dxSetParticles(@path + "particle", delay, center_x, center_y, 200)
    pulseData = dxSetSprite(@path + "pulse", delay, center_x, center_y, false, 100, 50)
    picPULSE, sprPULSE = pulseData[0], pulseData[1]
    #---------------------------------------------------------------------------
    # Sets up skip button & fade out.
    picBUTTON = dxSetSkipButton(delay)
    picFADE = dxSetFade(delay)
    ############################################################################
    # Animation start.
    ############################################################################
    # Fades in scene.
    picFADE.moveOpacity(delay, 8, 255)
    delay = picFADE.totalDuration
    picBG.setVisible(delay, true)
    arrBASES.first.setVisible(delay, true)
    picPOKE.setVisible(delay, true)
    picFADE.moveOpacity(delay, 8, 0)
    delay = picFADE.totalDuration
    picBUTTON.moveXY(delay, 6, 0, Graphics.height - 38)
    picBUTTON.moveXY(delay + 36, 6, 0, Graphics.height)
    #---------------------------------------------------------------------------
    # Darkens background/base tone; brightens Pokemon to white.
    picPOKE.setSE(delay, "DX Action")
    picBG.moveTone(delay, 15, Tone.new(-200, -200, -200))
    arrBASES.first.moveTone(delay, 15, Tone.new(-200, -200, -200))
    picPOKE.moveTone(delay, 8, Tone.new(-255, -255, -255, 255))
    picPOKE.moveColor(delay + 8, 6, Color.white)
    #---------------------------------------------------------------------------
    # Particles begin drawing in to Pokemon.
    repeat = delay
    2.times do |t|
      repeat -= 4 if t > 0
      arrPARTICLES.each_with_index do |p, i|
        p[0].setVisible(repeat + i, true)
        p[0].moveXY(repeat + i, 4, center_x, center_y)
        repeat = p[0].totalDuration
        p[0].setVisible(repeat + i, false)
        p[0].setXY(repeat + i, p[1], p[2])
        p[0].setZoom(repeat + i, 100)
        repeat = p[0].totalDuration - 2
      end
    end
    particleEnd = arrPARTICLES.last[0].totalDuration
    delay = picPOKE.totalDuration + 4
    #---------------------------------------------------------------------------
    # White orb engulfs Pokemon; Golden icon appears; orb expands away from Pokemon.
    picORB.setVisible(delay, true)
    picORB2.setVisible(delay, true)
    picORB.moveZoom(delay, 8, 100)
    picORB.moveOpacity(delay, 8, 255)
    picPOKE.moveOpacity(delay + 8, 4, 0)
    picORB2.setSE(particleEnd, "Anim/Scary Face")
    picORB2.moveOpacity(particleEnd, 16, 255)
    delay = picORB2.totalDuration
    picSHINE.setVisible(delay, true)
    picSHINE.moveOpacity(delay, 4, 255)
    if @bg_color
      picBG.moveColor(delay, 12, @bg_color)
      arrBASES.first.moveColor(delay, 12, @bg_color)
    end
    t = 0.5
    16.times do |i|
      picORB.setSE(delay, "Anim/Wring Out", 100, 60) if i == 0
      picORB.moveXY(delay, t, @pictureSprites[sprORB].x + 2, @pictureSprites[sprORB].y)
      picORB2.moveXY(delay, t, @pictureSprites[sprORB2].x + 2, @pictureSprites[sprORB2].y)
      picORB.moveXY(delay + t, t, @pictureSprites[sprORB].x - 2, @pictureSprites[sprORB].y)
      picORB2.moveXY(delay + t, t, @pictureSprites[sprORB2].x - 2, @pictureSprites[sprORB2].y)
      delay = picORB2.totalDuration
    end
    picORB2.setSE(delay, "Anim/Explosion")
    picORB2.moveZoom(delay, 8, 1000)
    picORB2.moveOpacity(delay, 8, 0)
    arrPOKE.each { |p, s| p.setVisible(delay + 6, true) }
    picORB.moveZoom(delay + 6, 8, 1000)
    picORB.moveOpacity(delay + 6, 8, 0)
    #---------------------------------------------------------------------------
    # White screen flash; shows silhouette of Golden Pokemon.
    picFADE.setColor(delay + 4, @bg_color || Color.white)
    picFADE.moveOpacity(delay + 4, 12, 255)
    delay = picFADE.totalDuration
    arrPOKE.last[0].setColor(delay, Color.black)
    picFADE.moveOpacity(delay, 6, 0)
    picFADE.setColor(delay + 6, Color.black)
    delay = picFADE.totalDuration
    #---------------------------------------------------------------------------
    # Golden Pokemon revealed; pulse expands outwards; overlay shown.
    picSHINE.setVisible(delay, true)
    picPULSE.setVisible(delay, true)
    picPULSE.moveZoom(delay, 5, 1000)
    picPULSE.moveOpacity(delay + 2, 5, 0)
    arrPOKE.last[0].moveColor(delay, 8, Color.new(0, 0, 0, 0))
    #---------------------------------------------------------------------------
    # Shakes Pokemon; plays cry; flashes overlay. Fades out.
    16.times do |i|
      if i > 0
        arrPOKE.each { |p, s| p.moveXY(delay, t, @pictureSprites[s].x, @pictureSprites[s].y + 2) }
        arrPOKE.each { |p, s| p.moveXY(delay + t, t, @pictureSprites[s].x, @pictureSprites[s].y - 2) }
        picSHINE.moveOpacity(delay + t, 2, 160)
      else
        picPOKE.setSE(delay + t, @cry_file) if @cry_file
      end
      picSHINE.moveOpacity(delay + t, 2, 240)
      delay = arrPOKE.last[0].totalDuration
    end
    picSHINE.moveOpacity(delay, 4, 0)
    picFADE.moveOpacity(delay + 20, 8, 255)
  end
end

#-------------------------------------------------------------------------------
# Calls the animation.
#-------------------------------------------------------------------------------
class Battle::Scene
  def pbShowGoldenReversion(idxBattler)
    goldenAnim = Animation::BattlerGoldenReversion.new(@sprites, @viewport, idxBattler, @battle)
    loop do
      if Input.press?(Input::ACTION)
        pbPlayCancelSE
        break 
      end
      goldenAnim.update
      pbUpdate
      break if goldenAnim.animDone?
    end
    goldenAnim.dispose
  end
end