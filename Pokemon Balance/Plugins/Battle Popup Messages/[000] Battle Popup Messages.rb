#===============================================================================
# Battle Popup Messages - Zeigt Effektivität, Kritische Treffer etc. als 
# Grafiken beim Pokémon an statt in der normalen Textbox
#===============================================================================

module BattlePopupMessages
  # Einstellungen
  POPUP_DURATION = 30        # Duración del popup en frames (30 = 0.75 segundos a 40fps).
  FADE_DURATION = 10         # Duración del desvanecimiento.
  SHOW_EFFECTIVENESS = true  # Zeige Effektivitäts-Grafiken
  SHOW_CRITICAL = true       # Zeige Kritischer-Treffer-Grafik
  SHOW_NO_EFFECT = true      # Zeige "Keine Wirkung"-Grafik
  SHOW_STAT_CHANGES = true   # Zeige Statuswertänderungs-Grafik
  
  # Pfade zu den Grafiken
  GRAPHICS_PATH = "Graphics/UI/Battle/Pop Up/animations/zv-battle-messages/popup-messages/"
  
  GRAPHIC_SUPER_EFFECTIVE = GRAPHICS_PATH + "super-effective"
  GRAPHIC_NOT_EFFECTIVE = GRAPHICS_PATH + "not-very-effective"
  GRAPHIC_CRITICAL = GRAPHICS_PATH + "critical-hit"
  GRAPHIC_NO_EFFECT = GRAPHICS_PATH + "no-effect"
  GRAPHIC_STAT_CHANGE = GRAPHICS_PATH + "stat-change"
  
  # Stat-Abkürzungen (wie im Summary Screen)
  STAT_NAMES = {
    :ATTACK => "Ataque",
    :DEFENSE => "Defensa",
    :SPECIAL_ATTACK => "Ataque Esp.",
    :SPECIAL_DEFENSE => "Defensa Esp.",
    :SPEED => "Velocidad",
    :ACCURACY => "Presición",
    :EVASION => "Evasión"
  }
end

#===============================================================================
# Popup Sprite Klasse - Zeigt Grafiken statt Text an
#===============================================================================
class BattlePopupSprite < Sprite
  attr_accessor :timer
  
  def initialize(x, y, graphic_path, text_overlay = nil, viewport)
    super(viewport)
    @timer = BattlePopupMessages::POPUP_DURATION
    @fade_start = BattlePopupMessages::POPUP_DURATION - BattlePopupMessages::FADE_DURATION
    
    # --- INICIO DE LA MODIFICACIÓN: Tamaño de popup consistente ---
    # Crear un bitmap base de tamaño fijo para todos los popups.
    bitmap = Bitmap.new(160, 42) # Ancho y alto fijos para todos los popups.
    begin
      # Cargar la imagen del cartel y dibujarla centrada en el bitmap base.
      graphic_bitmap = AnimatedBitmap.new(graphic_path)
      x_pos = (bitmap.width - graphic_bitmap.width) / 2
      y_pos = (bitmap.height - graphic_bitmap.height) / 2
      bitmap.blt(x_pos, y_pos, graphic_bitmap.bitmap, graphic_bitmap.bitmap.rect)
      graphic_bitmap.dispose
      
      # Wenn Text-Overlay vorhanden (für Stat-Changes), zeichne ihn drauf
      if text_overlay
        pbSetSystemFont(bitmap)
        bitmap.font.size = 12   # Tamaño de fuente reducido a 12
        bitmap.font.bold = true # Texto en negrita para mejor legibilidad
        
        # Text zentriert zeichnen
        text_x = 0
        text_y = (bitmap.height / 2)  # Ajuste vertical para centrar mejor
        text_width = bitmap.width - 4     # Un poco de margen
        text_height = 40
        
        # Shadow/Outline (schwarz) - für bessere Lesbarkeit
        [[-1, -1], [-1, 1], [1, -1], [1, 1]].each do |offset|
          bitmap.font.color = Color.new(0, 0, 0, 255)
          bitmap.draw_text(text_x + offset[0], text_y + offset[1], text_width, text_height, text_overlay, 1)
        end
        
        # Haupttext (weiß)
        bitmap.font.color = Color.new(255, 255, 255, 255)
        bitmap.draw_text(text_x, text_y, text_width, text_height, text_overlay, 1)
      end
      
    rescue => e
      # Fallback: Erstelle einfaches Text-Bitmap wenn Grafik nicht gefunden wird
      puts "Battle Popup: Grafik nicht gefunden: #{graphic_path}"
      puts "Error: #{e.message}"
      pbSetSystemFont(bitmap)
      bitmap.font.color = Color.new(255, 255, 255)
      bitmap.font.size = 20
      bitmap.draw_text(0, 0, 200, 50, text_overlay || "Grafik fehlt!", 1)
    end
    self.bitmap = bitmap
    # --- FIN DE LA MODIFICACIÓN ---
    
    self.zoom_x = 1.5 # Tamaño ajustado a 1.5x
    self.zoom_y = 1.5 # Tamaño ajustado a 1.5x
    self.x = x
    # --- INICIO DE LA CORRECCIÓN: Centrado Horizontal ---
    self.ox = self.bitmap.width / 2
    # --- FIN DE LA CORRECCIÓN ---
    self.y = y
    self.z = 999
    self.opacity = 255
    
    # Speichere Startposition für Bewegung
    @start_y = y
  end
  
  def update
    return if disposed?
    super
    @timer -= 1
    
    # Fade out
    if @timer <= @fade_start
      self.opacity = (@timer.to_f / @fade_start) * 255
      self.y -= 1.5  # Se mueve hacia arriba más rápido durante el desvanecimiento
    else
      self.y -= 1    # Se mueve hacia arriba más rápido
    end
    
    if @timer <= 0
      dispose
    end
  end
  
  def dispose
    self.bitmap&.dispose
    super
  end
end

#===============================================================================
# Battle Scene Erweiterung
#===============================================================================
class Battle::Scene
  alias popup_pbInitSprites pbInitSprites
  def pbInitSprites
    popup_pbInitSprites
    @popupSprites = []
  end
  
  # Lade transparente Message Box Grafik
  alias popup_pbCreateBackdropSprites pbCreateBackdropSprites
  def pbCreateBackdropSprites
    popup_pbCreateBackdropSprites
    
    # Ersetze die Message Box mit transparenter Grafik
    if @sprites["messageBox"]
      @sprites["messageBox"].dispose
      @sprites["messageBox"] = nil
    end
    
    # Lade transparente Message Box
    transparentMsgBox = pbAddSprite("messageBox", 0, Graphics.height - 96,
                                    "Graphics/UI/Battle/transparent_message", @viewport)
    transparentMsgBox.z = 195
  end
  
  alias popup_pbEndBattle pbEndBattle
  def pbEndBattle(result)
    @popupSprites.each { |sprite| sprite.dispose if sprite && !sprite.disposed? }
    @popupSprites.clear
    popup_pbEndBattle(result)
  end
  
  alias popup_pbUpdate pbUpdate
  def pbUpdate(cw = nil)
    popup_pbUpdate(cw)
    @popupSprites.each { |sprite| sprite.update if sprite && !sprite.disposed? }
    @popupSprites.delete_if { |sprite| sprite.nil? || sprite.disposed? }
  end
  
  # Zeigt einen Popup beim Pokémon an (mit Grafik)
  def pbShowBattlePopup(battlerIndex, graphic_path, text_overlay = nil)
    return if !@sprites["pokemon_#{battlerIndex}"]
    
    # Position des Pokémon-Sprites (zentriert)
    pokemonSprite = @sprites["pokemon_#{battlerIndex}"]
    
    # Berechne die richtige Position basierend auf dem Sprite
    if pokemonSprite && pokemonSprite.bitmap && !pokemonSprite.bitmap.disposed?
      # X ist die Mitte des Sprites
      x = pokemonSprite.x
      # Y ist über dem Sprite (nutze die tatsächliche Bitmap-Höhe)
      spriteHeight = pokemonSprite.bitmap.height
      y = pokemonSprite.y - (spriteHeight * 0.8)
    else
      # Fallback falls kein Sprite vorhanden
      x = pokemonSprite.x
      y = pokemonSprite.y - 40
    end
    
    # Erstelle Popup
    popup = BattlePopupSprite.new(x, y, graphic_path, text_overlay, @viewport)
    @popupSprites.push(popup)
  end
end

#===============================================================================
# Move Usage Überschreibungen
#===============================================================================
class Battle::Move
  alias popup_pbEffectivenessMessage pbEffectivenessMessage
  def pbEffectivenessMessage(user, target, numTargets = 1)
    return if target.damageState.disguise || target.damageState.iceFace
    
    # Zeige Popup statt Textbox
    if Effectiveness.super_effective?(target.damageState.typeMod)
      @battle.scene.pbShowBattlePopup(target.index, BattlePopupMessages::GRAPHIC_SUPER_EFFECTIVE)
    elsif Effectiveness.not_very_effective?(target.damageState.typeMod)
      @battle.scene.pbShowBattlePopup(target.index, BattlePopupMessages::GRAPHIC_NOT_EFFECTIVE)
    elsif Effectiveness.ineffective?(target.damageState.typeMod)
      @battle.scene.pbShowBattlePopup(target.index, BattlePopupMessages::GRAPHIC_NO_EFFECT)
    end
    # Keine Textbox anzeigen
  end

  alias popup_pbHitEffectivenessMessages pbHitEffectivenessMessages
  def pbHitEffectivenessMessages(user, target, numTargets = 1)
    return if target.damageState.disguise || target.damageState.iceFace
    
    # Critical Hit Popup
    if target.damageState.critical
      @battle.scene.pbShowBattlePopup(target.index, BattlePopupMessages::GRAPHIC_CRITICAL)
    end
    
    # Effectiveness Popup
    if Effectiveness.super_effective?(target.damageState.typeMod)
      @battle.scene.pbShowBattlePopup(target.index, BattlePopupMessages::GRAPHIC_SUPER_EFFECTIVE)
    elsif Effectiveness.not_very_effective?(target.damageState.typeMod)
      @battle.scene.pbShowBattlePopup(target.index, BattlePopupMessages::GRAPHIC_NOT_EFFECTIVE)
    elsif Effectiveness.ineffective?(target.damageState.typeMod)
      @battle.scene.pbShowBattlePopup(target.index, BattlePopupMessages::GRAPHIC_NO_EFFECT)
    end
    # Keine Textbox anzeigen
  end
end

#===============================================================================
# Immunität/Keine Wirkung Nachrichten
#===============================================================================
class Battle::Battler
  alias popup_pbMoveImmunityHealingAbility pbMoveImmunityHealingAbility
  def pbMoveImmunityHealingAbility(user, move, moveType, immuneType, show_message)
    result = popup_pbMoveImmunityHealingAbility(user, move, moveType, immuneType, show_message)
    
    if result && BattlePopupMessages::SHOW_NO_EFFECT && show_message
      # Zeige "Keine Wirkung!" Popup mit Grafik
      @battle.scene.pbShowBattlePopup(self.index, BattlePopupMessages::GRAPHIC_NO_EFFECT)
    end
    
    return result
  end
end

#===============================================================================
# Statuswertänderungen anzeigen
#===============================================================================
module Battle::Battler::BattlePopupsStatMessages
  def pbRaiseStatStage(*args)
    stat = args[0]
    increment = args[1]
    user = args[2]
    showAnim = args[3] || true
    ignoreContrary = args[4] || false
    if BattlePopupMessages::SHOW_STAT_CHANGES
      # Replicate the base logic without displaying text messages
      if hasActiveAbility?(:CONTRARY) && !ignoreContrary && !@battle.moldBreaker
        return pbLowerStatStage(*args)
      end
      increment = pbRaiseStatStageBasic(stat, increment, ignoreContrary)
      return false if increment <= 0
      @battle.pbCommonAnimation("StatUp", self) if showAnim
      if abilityActive?
        Battle::AbilityEffects.triggerOnStatGain(self.ability, self, stat, user)
      end
      return true
    end
    super
  end

  def pbLowerStatStage(*args)
    stat = args[0]
    increment = args[1]
    user = args[2]
    showAnim = args[3] || true
    ignoreContrary = args[4] || false
    mirrorArmorSplash = args[5] || 0
    ignoreMirrorArmor = args[6] || false
    if BattlePopupMessages::SHOW_STAT_CHANGES
      # Replicate the base logic without displaying text messages
      if !@battle.moldBreaker
        if hasActiveAbility?(:CONTRARY) && !ignoreContrary
          return pbRaiseStatStage(stat, increment, user, showAnim, true)
        end
        if hasActiveAbility?(:MIRRORARMOR) && !ignoreMirrorArmor && user && user.index != @index && !statStageAtMin?(stat)
          if mirrorArmorSplash < 2
            @battle.pbShowAbilitySplash(self)
            if !Battle::Scene::USE_ABILITY_SPLASH
              @battle.pbDisplay(_INTL("¡Se ha activado {2} de {1}!", pbThis(true), abilityName))
            end
          end
          ret = false
          if user.pbCanLowerStatStage?(stat, self, nil, true, ignoreContrary, true)
            ret = user.pbLowerStatStage(stat, increment, self, showAnim, ignoreContrary, mirrorArmorSplash + 1, true)
          end
          @battle.pbHideAbilitySplash(self) if mirrorArmorSplash.even?
          return ret
        end
      end
      increment = pbLowerStatStageBasic(stat, increment, ignoreContrary)
      return false if increment <= 0
      @battle.pbCommonAnimation("StatDown", self) if showAnim
      if abilityActive?
        Battle::AbilityEffects.triggerOnStatLoss(self.ability, self, stat, user)
      end
      return true
    end
    super
  end
end

class Battle::Battler
  # Hook für Stat-Erhöhung
  alias popup_pbRaiseStatStageBasic pbRaiseStatStageBasic
  def pbRaiseStatStageBasic(stat, increment, ignoreContrary = false)
    # Speichere die aktuelle Stage BEVOR die Änderung
    old_stage = @stages[stat]
    
    result = popup_pbRaiseStatStageBasic(stat, increment, ignoreContrary)
    
    # Berechne die tatsächliche Änderung
    actual_change = @stages[stat] - old_stage
    
    if actual_change > 0 && BattlePopupMessages::SHOW_STAT_CHANGES
      # Erstelle Text-Overlay: "Ang +1" oder "Sp.Ang +2" etc.
      stat_name = BattlePopupMessages::STAT_NAMES[stat] || GameData::Stat.get(stat).name
      text = "#{stat_name} +#{actual_change}"
      
      # Zeige stat-change.png mit Text-Overlay
      @battle.scene.pbShowBattlePopup(self.index, BattlePopupMessages::GRAPHIC_STAT_CHANGE, text)
    end
    
    return result
  end
  
  # Hook für Stat-Senkung
  alias popup_pbLowerStatStageBasic pbLowerStatStageBasic
  def pbLowerStatStageBasic(stat, increment, ignoreContrary = false)
    # Speichere die aktuelle Stage BEVOR die Änderung
    old_stage = @stages[stat]
    
    result = popup_pbLowerStatStageBasic(stat, increment, ignoreContrary)
    
    # Berechne die tatsächliche Änderung (absoluter Wert)
    actual_change = old_stage - @stages[stat]
    
    if actual_change > 0 && BattlePopupMessages::SHOW_STAT_CHANGES
      # Erstelle Text-Overlay: "Ang -1" oder "Init -2" etc.
      stat_name = BattlePopupMessages::STAT_NAMES[stat] || GameData::Stat.get(stat).name
      text = "#{stat_name} -#{actual_change}"
      
      # Zeige stat-change.png mit Text-Overlay
      @battle.scene.pbShowBattlePopup(self.index, BattlePopupMessages::GRAPHIC_STAT_CHANGE, text)
    end
    
    return result
  end
end

#===============================================================================
# Optionale Konfiguration über Debug Menu
#===============================================================================
MenuHandlers.add(:debug_menu, :toggle_battle_popups, {
  "name"        => _INTL("Battle Popup Messages"),
  "parent"      => :deluxe_plugins_menu,
  "description" => _INTL("Turn Battle Popup Messages on/off."),
  "effect"      => proc {
    if !defined?(BattlePopupMessages::SHOW_EFFECTIVENESS)
      pbMessage(_INTL("The Battle Popup Messages plugin is not loaded."))
      next
    end
    
    cmd = 0
    loop do
      cmds = []
      cmds.push(_INTL("Effektivität: {1}", BattlePopupMessages::SHOW_EFFECTIVENESS ? "AN" : "AUS"))
      cmds.push(_INTL("Kritische Treffer: {1}", BattlePopupMessages::SHOW_CRITICAL ? "AN" : "AUS"))
      cmds.push(_INTL("Keine Wirkung: {1}", BattlePopupMessages::SHOW_NO_EFFECT ? "AN" : "AUS"))
      cmds.push(_INTL("Statuswertänderungen: {1}", BattlePopupMessages::SHOW_STAT_CHANGES ? "AN" : "AUS"))
      cmds.push(_INTL("Zurück"))
      
      cmd = pbMessage(_INTL("Welche Popup-Nachrichten sollen angezeigt werden?"), cmds, -1, nil, cmd)
      break if cmd < 0 || cmd == cmds.length - 1
      
      case cmd
      when 0
        BattlePopupMessages.const_set(:SHOW_EFFECTIVENESS, !BattlePopupMessages::SHOW_EFFECTIVENESS)
      when 1
        BattlePopupMessages.const_set(:SHOW_CRITICAL, !BattlePopupMessages::SHOW_CRITICAL)
      when 2
        BattlePopupMessages.const_set(:SHOW_NO_EFFECT, !BattlePopupMessages::SHOW_NO_EFFECT)
      when 3
        BattlePopupMessages.const_set(:SHOW_STAT_CHANGES, !BattlePopupMessages::SHOW_STAT_CHANGES)
      end
    end
  }
})

#===============================================================================
# Silenciar mensaje de texto de cambio de estadísticas
#===============================================================================
module Battle::Scene::BattlePopupsSilence
  # Modificamos el método que muestra el mensaje de texto.
  def pbDisplayStatChange(battler, stat, change)
    # Si la opción de mostrar popups de estadísticas está activada, no hacemos nada.
    # Esto evita que se muestre el mensaje de texto original.
    return if BattlePopupMessages::SHOW_STAT_CHANGES
    # Si la opción está desactivada, llamamos al método original para que muestre el texto.
    super
  end
end

class Battle::Scene
  prepend Battle::Scene::BattlePopupsSilence
end

class Battle::Battler
  prepend Battle::Battler::BattlePopupsStatMessages
end

#===============================================================================
# Silenciar mensaje de texto de cambio de estadísticas (Parte 2)
#===============================================================================
module Battle::Scene::BattlePopupsSilence
  # Modificamos el método que muestra el mensaje de texto en la escena.
  def pbDisplayStatChange(battler, stat, change)
    # Si la opción de mostrar popups de estadísticas está activada, no hacemos nada.
    return if BattlePopupMessages::SHOW_STAT_CHANGES
    # Si la opción está desactivada, llamamos al método original para que muestre el texto.
    super
  end
end

class Battle::Scene
  prepend Battle::Scene::BattlePopupsSilence
end
