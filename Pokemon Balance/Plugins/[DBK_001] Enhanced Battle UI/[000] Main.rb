#===============================================================================
# Settings.
#===============================================================================
module Settings
  # Definidos en PluginSettings
end


#===============================================================================
# Initializes Battle UI elements.
#===============================================================================
class Battle::Scene
  #-----------------------------------------------------------------------------
  # White text.
  #-----------------------------------------------------------------------------
  BASE_LIGHT     = Color.new(232, 232, 232)
  SHADOW_LIGHT   = Color.new(72, 72, 72)
  #-----------------------------------------------------------------------------
  # Black text.
  #-----------------------------------------------------------------------------
  BASE_DARK      = Color.new(56, 56, 56)
  SHADOW_DARK    = Color.new(184, 184, 184)
  #-----------------------------------------------------------------------------
  # Green text. Used to display bonuses.
  #-----------------------------------------------------------------------------
  BASE_RAISED    = Color.new(50, 205, 50)
  SHADOW_RAISED  = Color.new(9, 121, 105)
  #-----------------------------------------------------------------------------
  # Red text. Used to display penalties.
  #-----------------------------------------------------------------------------
  BASE_LOWERED   = Color.new(248, 72, 72)
  SHADOW_LOWERED = Color.new(136, 48, 48)

  #-----------------------------------------------------------------------------
  # Aliased to initilize UI elements.
  #-----------------------------------------------------------------------------
  alias enhanced_pbInitSprites pbInitSprites
  def pbInitSprites
    enhanced_pbInitSprites
    if !pbInSafari?
      @path = Settings::BATTLE_UI_GRAPHICS_PATH
      #-------------------------------------------------------------------------
      # Move info UI.
      #-------------------------------------------------------------------------
      @moveUIToggle = false
      @sprites["moveinfo"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
      @sprites["moveinfo"].z = 300
      @sprites["moveinfo"].visible = @moveUIToggle
      pbSetSmallFont(@sprites["moveinfo"].bitmap)
      @moveUIOverlay = @sprites["moveinfo"].bitmap
      #-------------------------------------------------------------------------
      # Battle info UI.
      #-------------------------------------------------------------------------
      @infoUIToggle = false
      @sprites["battleinfo"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
      @sprites["battleinfo"].z = 300
      @sprites["battleinfo"].visible = @infoUIToggle
      pbSetSmallFont(@sprites["battleinfo"].bitmap)
      @infoUIOverlay = @sprites["battleinfo"].bitmap
      @sprites["leftarrow"] = AnimatedSprite.new("Graphics/UI/left_arrow", 8, 40, 28, 2, @viewport)
      @sprites["leftarrow"].x = -2
      @sprites["leftarrow"].y = 71
      @sprites["leftarrow"].z = 300
      @sprites["leftarrow"].play
      @sprites["leftarrow"].visible = false
      @sprites["rightarrow"] = AnimatedSprite.new("Graphics/UI/right_arrow", 8, 40, 28, 2, @viewport)
      @sprites["rightarrow"].x = Graphics.width - 38
      @sprites["rightarrow"].y = 71
      @sprites["rightarrow"].z = 300
      @sprites["rightarrow"].play
      @sprites["rightarrow"].visible = false
      #-------------------------------------------------------------------------
      # Battler sprites.
      #-------------------------------------------------------------------------
      @battle.allBattlers.each do |b|
        @sprites["info_icon#{b.index}"] = PokemonIconSprite.new(b.pokemon, @viewport)
        @sprites["info_icon#{b.index}"].setOffset(PictureOrigin::CENTER)
        @sprites["info_icon#{b.index}"].visible = false
        @sprites["info_icon#{b.index}"].z = 300
        pbAddSpriteOutline(["info_icon#{b.index}", @viewport, b.pokemon, PictureOrigin::CENTER])
      end
    end
  end

  alias enhanced_pbCreateBackdropSprites pbCreateBackdropSprites
  def pbCreateBackdropSprites
    enhanced_pbCreateBackdropSprites
    if !pbInSafari?
      button1 = pbAddSprite("button1", 388, 7, "Graphics/UI/Battle/DBK/boton1", @viewport)
      button1.z = 300
      if $DEBUG
        button2 = pbAddSprite("button2", 245, 7, "Graphics/UI/Battle/DBK/boton2", @viewport) 
        button2.z = 300
      end
    end
    pbHideButtons
  end
  
  #-----------------------------------------------------------------------------
  # Utilities for hiding UI elements.
  #-----------------------------------------------------------------------------
  def pbHideMoveInfo
    return if pbInSafari?
    @moveUIToggle = false
    @sprites["moveinfo"].visible = false
    @moveUIOverlay.clear
  end
  
  def pbHideBattleInfo
    return if pbInSafari?
    @infoUIToggle = false
    @sprites["battleinfo"].visible = false
    @infoUIOverlay.clear
  end
  
  def pbHideInfoIcons
    return if pbInSafari?
    @battle.allBattlers.each do |b|
      @sprites["info_icon#{b.index}"].visible = false
    end
  end

  def pbHideButtons
    @sprites["button1"].visible = false if @sprites["button1"]
    @sprites["button2"].visible = false if $DEBUG && @sprites["button2"]
    @sprites["button3"].visible = false if @sprites["button3"]
  end

  def pbShowButtons(all = false)
    @sprites["button1"].visible = true if @sprites["button1"]
    @sprites["button2"].visible = true if $DEBUG && @sprites["button2"]
    @sprites["button3"].visible = true if @sprites["button3"] && all 
  end
  
  def pbHideInfoUI
    pbHideMoveInfo
    pbHideBattleInfo
    pbHideInfoIcons
  end
  
  #-----------------------------------------------------------------------------
  # Aliased for toggling the display of UI elements in the fight menu.
  #-----------------------------------------------------------------------------
  alias enhanced_pbFightMenu_Confirm pbFightMenu_Confirm
  def pbFightMenu_Confirm(*args)
    pbHideInfoUI
    enhanced_pbFightMenu_Confirm(*args)
  end
  
  alias enhanced_pbFightMenu_Cancel pbFightMenu_Cancel
  def pbFightMenu_Cancel(*args)
    pbHideInfoUI
    enhanced_pbFightMenu_Cancel(*args)
  end
  
  alias enhanced_pbFightMenu_Shift pbFightMenu_Shift
  def pbFightMenu_Shift(*args)
    pbHideInfoUI
    enhanced_pbFightMenu_Shift(*args)
  end
  
  alias enhanced_pbFightMenu_Action pbFightMenu_Action
  def pbFightMenu_Action(*args)
    enhanced_pbFightMenu_Action(*args)
    pbUpdateMoveInfoWindow(*args)
  end
  
  alias enhanced_pbFightMenu_Update pbFightMenu_Update
  def pbFightMenu_Update(*args)
    pbUpdateMoveInfoWindow(*args)
  end
  
  alias enhanced_pbFightMenu_Extra pbFightMenu_Extra
  def pbFightMenu_Extra(*args)
    return if pbInSafari?
    if Input.trigger?(Input::JUMPUP)
      pbToggleBattleInfo
    elsif Input.trigger?(Input::JUMPDOWN)
      pbToggleMoveInfo(*args)
    end
  end
  
  alias enhanced_pbFightMenu_End pbFightMenu_End
  def pbFightMenu_End(*args)
    pbHideInfoUI
  end
end

#===============================================================================
# Allows the display of correct move category for moves that change their category.
#===============================================================================
class Battle::Move
  attr_accessor :calcCategory
end