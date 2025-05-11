module Settings
 #=============================================================================

  # El ANCHO por defecto de la pantalla en píxeles (en escala 1.0).
  SCREEN_WIDTH  = 640
  # El ALTO de la pantalla en píxelex (en escala 1.0).
  SCREEN_HEIGHT = 440
  # El tamaño de la pantalla por defecto. 
  #   * Posibles valores: 0.5, 1.0, 1.5 y 2.0.
  SCREEN_SCALE  = 1.0

  #=============================================================================
  # Status Settings (Frostbite)
  #=============================================================================
  # Cuando está en true efectos que normalmente congelan generaran 
  # la congelacion de Hisui
  #-----------------------------------------------------------------------------
  FREEZE_EFFECTS_CAUSE_FROSTBITE = true
  SLEEP_EFFECTS_CAUSE_DROWSY     = true
  
  
  ENABLE_SKIP_TEXT = false

################################################################################
#  CONFIGURACIÓN DE LOS SPRITES ANIMADOS
################################################################################
#===============================================================================
# * Constantes para sprites animados de Pokémon
# * Para cambiar la posición del sprites de espalda de Pokémon en la batalla, 
#   selecciona y presiona
# * CTRL + Shift + F en la siguiente línea de código:
# * sprite.y += (metrics[MetricBattlerPlayerY][species] || 0)*2
#===============================================================================
FRONTSPRITE_SCALE = 1 #2
BACKSPRITE_SCALE  = 1 #3
################################################################################
end

module Settings

MOSTRAR_PANEL_REP_EXP = false

end

class IntroEventScene < EventScene
  # Splash screen images that appear for a few seconds and then disappear.
  SPLASH_IMAGES         = ["splash1"]
end  