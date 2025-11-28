#===============================================================================
# [Carnek] Battle Popups
# Creado desde cero con texto dibujado para máxima compatibilidad. Versión Definitiva.
#===============================================================================
#
# INSTRUCCIONES:
# Este script no necesita imágenes. Simplemente actívalo y funcionará.
# Puedes personalizar los textos, colores y la animación en la configuración.
#
#===============================================================================

#-------------------------------------------------------------------------------
# Módulo de Configuración
#-------------------------------------------------------------------------------
module BattlePopups
  # --- Habilitar/Deshabilitar Carteles ---
  SHOW_SUPER_EFFECTIVE    = true  # Muestra "¡Súper eficaz!"
  SHOW_NOT_VERY_EFFECTIVE = true  # Muestra "No es muy eficaz..."
  SHOW_CRITICAL_HIT       = true  # Muestra "¡Golpe Crítico!"
  SHOW_FAILED             = true  # Muestra "¡Falló!"

  # --- Textos y Colores ---
  SUPER_EFFECTIVE_TEXT    = _INTL("¡Súper eficaz!")
  SUPER_EFFECTIVE_COLOR   = Color.new(0, 248, 0)

  NOT_VERY_EFFECTIVE_TEXT = _INTL("No es muy eficaz...")
  NOT_VERY_EFFECTIVE_COLOR = Color.new(248, 128, 120)

  CRITICAL_HIT_TEXT       = _INTL("¡Golpe Crítico!")
  CRITICAL_HIT_COLOR      = Color.new(248, 248, 0)

  FAILED_TEXT             = _INTL("¡Falló!")
  FAILED_COLOR            = Color.new(208, 208, 208)

  # --- Configuración de la Animación ---
  ANIMATION_DURATION = 0.4 # Duración total de la animación en segundos.
  RISE_DISTANCE      = 24  # Píxeles que el cartel se moverá hacia arriba.
  Z_INDEX            = 99999 # Z-index para que los carteles aparezcan por encima de todo.
end

#-------------------------------------------------------------------------------
# Clase base para los carteles (Popup)
#-------------------------------------------------------------------------------
class Battle::Scene::Popup
  def initialize(viewport, target_sprite, text, color)
    @viewport      = viewport
    @target_sprite = target_sprite
    @disposed      = false

    @popup_sprite = Sprite.new(@viewport)
    # Crear un bitmap y dibujar el texto en él
    @popup_sprite.bitmap = Bitmap.new(200, 48)
    pbSetSystemFont(@popup_sprite.bitmap)
    @popup_sprite.bitmap.font.size  = 26
    @popup_sprite.bitmap.font.bold  = true
    @popup_sprite.bitmap.font.color = color
    @popup_sprite.bitmap.draw_text(0, 0, 200, 48, text, 1) # 1 = centrado

    @popup_sprite.ox = @popup_sprite.bitmap.width / 2
    @popup_sprite.oy = @popup_sprite.bitmap.height
    @popup_sprite.z  = BattlePopups::Z_INDEX

    @start_time = Graphics.frame_count
    @duration   = (BattlePopups::ANIMATION_DURATION * Graphics.frame_rate).to_i
    @animating  = true # La animación está activa

    update_position
    @popup_sprite.opacity = 0
  end

  def update
    return if !@animating || disposed?
    elapsed = Graphics.frame_count - @start_time
    progress = elapsed.to_f / @duration
    if progress >= 1.0
      dispose
      return
    end
    update_position(progress)
    update_opacity(progress)
  end

  def update_position(progress = 0)
    return if !@target_sprite || @target_sprite.disposed? || disposed?
    @popup_sprite.x = @target_sprite.x
    @popup_sprite.y = @target_sprite.y - (BattlePopups::RISE_DISTANCE * progress)
  end

  def update_opacity(progress)
    if progress < 0.2
      @popup_sprite.opacity = (progress / 0.2) * 255
    elsif progress > 0.8
      @popup_sprite.opacity = (1.0 - ((progress - 0.8) / 0.2)) * 255
    else
      @popup_sprite.opacity = 255
    end
  end

  def dispose
    return if @disposed
    @popup_sprite.dispose
    @disposed  = true
    @animating = false
  end

  def disposed?; @disposed; end
end

#-------------------------------------------------------------------------------
# Clases específicas para cada tipo de cartel
#-------------------------------------------------------------------------------
class Battle::Scene::SuperEffectivePopup < Battle::Scene::Popup
  def initialize(viewport, target_sprite)
    super(viewport, target_sprite, BattlePopups::SUPER_EFFECTIVE_TEXT, BattlePopups::SUPER_EFFECTIVE_COLOR)
  end
end

class Battle::Scene::NotVeryEffectivePopup < Battle::Scene::Popup
  def initialize(viewport, target_sprite)
    super(viewport, target_sprite, BattlePopups::NOT_VERY_EFFECTIVE_TEXT, BattlePopups::NOT_VERY_EFFECTIVE_COLOR)
  end
end

class Battle::Scene::CriticalHitPopup < Battle::Scene::Popup
  def initialize(viewport, target_sprite)
    super(viewport, target_sprite, BattlePopups::CRITICAL_HIT_TEXT, BattlePopups::CRITICAL_HIT_COLOR)
  end
end

class Battle::Scene::FailedMovePopup < Battle::Scene::Popup
  def initialize(viewport, target_sprite)
    super(viewport, target_sprite, BattlePopups::FAILED_TEXT, BattlePopups::FAILED_COLOR)
  end
end

#-------------------------------------------------------------------------------
# Hooks para interceptar los mensajes de batalla (método compatible)
#-------------------------------------------------------------------------------
module Battle::Scene::BattlePopups
  # --- Mensaje de Efectividad ---
  def pbEffectivenessMessage(effectiveness, target, numTargets = 1)
    # Mostrar cartel de Super Eficaz
    if effectiveness > 1 && BattlePopups::SHOW_SUPER_EFFECTIVE
      battler_sprite = @sprites["pokemon_#{target.index}"]
      battler_sprite.animations.push(Battle::Scene::SuperEffectivePopup.new(@viewport, battler_sprite))
      return
    end
    # Mostrar cartel de Poco Eficaz
    if effectiveness > 0 && effectiveness < 1 && BattlePopups::SHOW_NOT_VERY_EFFECTIVE
      battler_sprite = @sprites["pokemon_#{target.index}"]
      battler_sprite.animations.push(Battle::Scene::NotVeryEffectivePopup.new(@viewport, battler_sprite))
      return
    end
    # Si no se muestra ningún cartel, usar el método original para mostrar el texto
    super
  end

  # --- Mensaje de Golpe Crítico ---
  def pbCriticalHitMessage(target)
    if BattlePopups::SHOW_CRITICAL_HIT
      battler_sprite = @sprites["pokemon_#{target.index}"]
      battler_sprite.animations.push(Battle::Scene::CriticalHitPopup.new(@viewport, battler_sprite))
    else
      super
    end
  end

  # --- Mensaje de Fallo ---
  def pbMissMessage(user, target)
    if BattlePopups::SHOW_FAILED
      battler_sprite = @sprites["pokemon_#{target.index}"]
      battler_sprite.animations.push(Battle::Scene::FailedMovePopup.new(@viewport, battler_sprite))
    else
      super
    end
  end
end

class Battle::Scene
  prepend Battle::Scene::BattlePopups
end

module Battle::Move::BattlePopupsSilence
  # Silencia el mensaje de texto si se va a mostrar un cartel
  def pbEffectivenessMessage(user, target, numTargets = 1)
    return if Effectiveness.super_effective?(target.damageState.typeMod) && BattlePopups::SHOW_SUPER_EFFECTIVE
    return if Effectiveness.not_very_effective?(target.damageState.typeMod) && BattlePopups::SHOW_NOT_VERY_EFFECTIVE
    super
  end

  # Silencia el mensaje de texto si se va a mostrar un cartel
  def pbCriticalHitMessage(target)
    return if BattlePopups::SHOW_CRITICAL_HIT
    super
  end

  # Silencia el mensaje de texto si se va a mostrar un cartel
  def pbMissMessage(user, target)
    return if BattlePopups::SHOW_FAILED
    super
  end
end

class Battle::Move
  prepend Battle::Move::BattlePopupsSilence
end
