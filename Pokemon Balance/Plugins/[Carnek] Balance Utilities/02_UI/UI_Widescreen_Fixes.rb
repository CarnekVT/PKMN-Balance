#===============================================================================
# Módulo de Configuración para Ajustes de UI Widescreen
#===============================================================================
# En este módulo puedes ajustar fácilmente los valores de posición para cada
# interfaz modificada. Cambia los números para mover los elementos en la pantalla.
#===============================================================================
module WidescreenUI
  # --- Pantalla de Carga (Load Screen) ---
  # Ajusta la posición vertical (Y) de los paneles de guardado.
  # Un valor más bajo mueve los paneles hacia arriba.
  LOAD_SCREEN_Y_OFFSET = 12
  # Posición del sprite del jugador [X, Y]
  LOAD_PLAYER_POS = [152, 92]
  # Posición inicial del primer icono del equipo [X, Y]
  LOAD_PARTY_ICONS_START_POS = [404, 92]
  # Espaciado entre los iconos del equipo [X, Y]
  LOAD_PARTY_ICONS_SPACING = [66, 50]
  # Ajustes de posición para los textos de la Pantalla de Carga.
  # [Coordenada X, Coordenada Y]
  LOAD_TEXT_TITLE_POS         = [72, 16]   # "Continuar", "Juego Nuevo", etc.
  LOAD_TEXT_PLAYER_NAME_POS   = [152, 70]  # Nombre del jugador
  LOAD_TEXT_MAP_NAME_POS      = [466, 16]  # Nombre del mapa
  LOAD_TEXT_BADGES_LABEL_POS  = [72, 118]  # Etiqueta "Medallas:"
  LOAD_TEXT_BADGES_VALUE_POS  = [266, 118]  # Número de medallas
  LOAD_TEXT_POKEDEX_LABEL_POS = [72, 150]  # Etiqueta "Pokédex:"
  LOAD_TEXT_POKEDEX_VALUE_POS = [266, 150]  # Número de avistados
  LOAD_TEXT_PLAYTIME_LABEL_POS= [72, 182]  # Etiqueta "Tiempo:"
  LOAD_TEXT_PLAYTIME_VALUE_POS= [266, 182]  # Tiempo de juego
  LOAD_TEXT_GENERAL_POS       = [72, 14]   # Para "Juego Nuevo", "Opciones", etc.
  
  # --- Interfaz de Batalla Mejorada (Enhanced Battle UI) ---
  # Ajusta la posición vertical (Y) de toda la interfaz de información.
  # Un valor más bajo mueve la interfaz hacia arriba.
  BATTLE_INFO_Y_OFFSET = 0
  # --- Posiciones de los elementos gráficos de la UI de Batalla ---
  # Coordenadas absolutas [X, Y] para los elementos principales.
  BATTLE_UI_BASE_POS          = [28, 24]   # Posición base de toda la UI
  BATTLE_UI_ICON_POS          = [80, 86]   # Icono del Pokémon
  BATTLE_UI_PANEL_POS         = [268, 0]   # Panel derecho de información
  # Coordenadas relativas a BATTLE_UI_BASE_POS para otros elementos.
  BATTLE_GFX_LEVEL_POS        = [36, 106]  # Fondo del nivel
  BATTLE_GFX_GENDER_POS       = [148, 22]  # Icono de género
  BATTLE_GFX_OWNER_TAG_POS    = [-34, 6]   # Etiqueta de Entrenador (si no es salvaje)
  BATTLE_GFX_HP_BAR_POS       = [124, 86]  # Barra de vida
  BATTLE_GFX_STATUS_POS       = [86, 104]  # Icono de estado
  BATTLE_GFX_SHINY_POS        = [142, 102] # Icono de shiny
  # Coordenadas relativas para elementos de Pokémon del jugador.
  BATTLE_GFX_PLAYER_OWNER_POS = [36, 10]   # Etiqueta "Datos"
  BATTLE_GFX_ABILITY_CURSOR_POS = [60, 62] # Fondo de Habilidad (relativo a panelX)
  BATTLE_GFX_ITEM_CURSOR_POS    = [60, 86] # Fondo de Objeto (relativo a panelX)
  BATTLE_GFX_HP_TEXT_BG_POS   = [174, 98]   # [X, Y] posición absoluta
  # Coordenadas para los efectos y sus sliders.
  BATTLE_GFX_EFFECTS_POS          = [62, 0]   # Desplazamiento [X, Y] para el panel de efectos
  BATTLE_GFX_EFFECTS_SLIDER_BASE_POS = [670, 142] # Posición [X, Y] de la base del slider
  BATTLE_GFX_EFFECTS_SLIDER_POS      = [670, 142] # Posición [X, Y] del slider
  # Coordenadas para los cambios de estadísticas.
  BATTLE_GFX_STATS_CHANGE_POS = [140, 136] # Desplazamiento [X, Y] relativo a la base de la UI

  # Ajustes de posición para los textos de la UI de Batalla.
  # Son desplazamientos relativos a la posición de la UI.
  # [Desplazamiento X, Desplazamiento Y]
  BATTLE_TEXT_NAME_OFFSET     = [0, 0] # Nombre del Pokémon
  BATTLE_TEXT_LEVEL_OFFSET    = [6, 0]   # Nivel
  BATTLE_TEXT_MOVE_OFFSET     = [55, 0]   # Último movimiento usado
  BATTLE_TEXT_TURN_OFFSET     = [0, 0]   # Contador de turnos
  BATTLE_TEXT_OWNER_OFFSET    = [0, 0]   # Nombre del entrenador
  BATTLE_TEXT_ABILITY_OFFSET  = [-22, 0]   # Habilidad
  BATTLE_TEXT_ITEM_OFFSET     = [-22, 0]   # Objeto
  BATTLE_TEXT_HP_OFFSET       = [20, 0]   # Texto de PS (ej: 100/100)
  BATTLE_TEXT_STATS_OFFSETS = [
    [5, 0], # Ataque
    [5, 0], # Defensa
    [5, 0], # At. Esp.
    [5, 0], # Def. Esp.
    [5, 0], # Velocidad
    [5, 0], # Precisión
    [5, 0], # Evasión
    [5, 0]  # Críticos
  ]

  # --- Move Info UI ---
  # Ajusta la posición base de la UI de información de movimientos.
  # Un valor más bajo mueve la interfaz hacia arriba o izquierda.
  MOVE_UI_X_OFFSET = 0
  MOVE_UI_Y_OFFSET = 0
  # Posiciones relativas a la base para elementos gráficos.
  MOVE_GFX_TYPE_POS          = [364, 6]  # Icono de tipo
  MOVE_GFX_CATEGORY_POS      = [446, 6]  # Icono de categoría
  # Posiciones relativas para textos.
  MOVE_TEXT_NAME_POS         = [20, 12]  # Nombre del movimiento
  MOVE_TEXT_POWER_POS        = [318, 40] # Poder
  MOVE_TEXT_ACCURACY_POS     = [445, 40] # Precisión
  MOVE_TEXT_PRIORITY_POS     = [558, 40] # Prioridad
  MOVE_TEXT_EFFECT_POS       = [543, 12] # Efecto
  MOVE_TEXT_BONUS_POS        = [18, 132] # Bonus
  MOVE_TEXT_DESCRIPTION_POS  = [18, 74]  # Descripción

  # --- Pantalla de Resumen (Summary Screen) ---
  # Ajusta la posición vertical (Y) del icono del objeto equipado.
  # Un valor más bajo mueve el icono hacia arriba.
  SUMMARY_ITEM_Y_OFFSET = 320
  # Ajustes de posición para los textos de la pantalla de resumen.
  # [Coordenada X, Coordenada Y]
  SUMMARY_TEXT_POKENAME_POS = [46, 62]  # Nombre del Pokémon
  SUMMARY_TEXT_LEVEL_POS    = [56, 114] # Nivel del Pokémon
  SUMMARY_TEXT_ITEM_POS     = [64, 372] # Nombre del objeto

  # --- Pokédex (Ajuste de ejemplo) ---
  # Ajusta la posición vertical (Y) de la lista de Pokémon.
  POKEDEX_LIST_Y_OFFSET = 0 # Cambiar según sea necesario

  # --- Movimientos de Campo (Ajuste de ejemplo) ---
  # Ajusta la posición vertical (Y) de la interfaz de movimientos de campo.
  FIELD_MOVE_Y_OFFSET = 0 # Cambiar según sea necesario
end

#===============================================================================
# Ajustes para la Pantalla de Carga (Load Screen) - Panel
#===============================================================================
class PokemonLoadPanel < Sprite
  def refresh
    return if @refreshing
    return if disposed?
    @refreshing = true
    if !self.bitmap || self.bitmap.disposed?
      self.bitmap = Bitmap.new(@bgbitmap.width, 222)
      pbSetSystemFont(self.bitmap)
    end
    if @refreshBitmap
      @refreshBitmap = false
      self.bitmap&.clear
      if @isContinue
        self.bitmap.blt(0, 0, @bgbitmap.bitmap, Rect.new(0, (@selected) ? 222 : 0, @bgbitmap.width, 222))
      else
        self.bitmap.blt(0, 0, @bgbitmap.bitmap, Rect.new(0, 444 + ((@selected) ? 46 : 0), @bgbitmap.width, 46))
      end
      textpos = []
      if @isContinue
        # --- INICIO DE LA MODIFICACIÓN PARA TEXTO CONFIGURABLE ---
        textpos.push([@title, WidescreenUI::LOAD_TEXT_TITLE_POS[0], WidescreenUI::LOAD_TEXT_TITLE_POS[1], :left, TEXT_COLOR, TEXT_SHADOW_COLOR])
        
        textpos.push([_INTL("Medallas:"), WidescreenUI::LOAD_TEXT_BADGES_LABEL_POS[0], WidescreenUI::LOAD_TEXT_BADGES_LABEL_POS[1], :left, TEXT_COLOR, TEXT_SHADOW_COLOR])
        textpos.push([@trainer.badge_count.to_s, WidescreenUI::LOAD_TEXT_BADGES_VALUE_POS[0], WidescreenUI::LOAD_TEXT_BADGES_VALUE_POS[1], :right, TEXT_COLOR, TEXT_SHADOW_COLOR])
        
        textpos.push([_INTL("Pokédex:"), WidescreenUI::LOAD_TEXT_POKEDEX_LABEL_POS[0], WidescreenUI::LOAD_TEXT_POKEDEX_LABEL_POS[1], :left, TEXT_COLOR, TEXT_SHADOW_COLOR])
        textpos.push([@trainer.pokedex.seen_count.to_s, WidescreenUI::LOAD_TEXT_POKEDEX_VALUE_POS[0], WidescreenUI::LOAD_TEXT_POKEDEX_VALUE_POS[1], :right, TEXT_COLOR, TEXT_SHADOW_COLOR])
        
        textpos.push([_INTL("Tiempo:"), WidescreenUI::LOAD_TEXT_PLAYTIME_LABEL_POS[0], WidescreenUI::LOAD_TEXT_PLAYTIME_LABEL_POS[1], :left, TEXT_COLOR, TEXT_SHADOW_COLOR])
        hour = @totalsec / 60 / 60
        min  = @totalsec / 60 % 60
        if hour > 0
          textpos.push([_INTL("{1}h {2}m", hour, min), WidescreenUI::LOAD_TEXT_PLAYTIME_VALUE_POS[0], WidescreenUI::LOAD_TEXT_PLAYTIME_VALUE_POS[1], :right, TEXT_COLOR, TEXT_SHADOW_COLOR])
        else
          textpos.push([_INTL("{1}m", min), WidescreenUI::LOAD_TEXT_PLAYTIME_VALUE_POS[0], WidescreenUI::LOAD_TEXT_PLAYTIME_VALUE_POS[1], :right, TEXT_COLOR, TEXT_SHADOW_COLOR])
        end
        
        if @trainer.male?
          textpos.push([@trainer.name, WidescreenUI::LOAD_TEXT_PLAYER_NAME_POS[0], WidescreenUI::LOAD_TEXT_PLAYER_NAME_POS[1], :left, MALE_TEXT_COLOR, MALE_TEXT_SHADOW_COLOR])
        elsif @trainer.female?
          textpos.push([@trainer.name, WidescreenUI::LOAD_TEXT_PLAYER_NAME_POS[0], WidescreenUI::LOAD_TEXT_PLAYER_NAME_POS[1], :left, FEMALE_TEXT_COLOR, FEMALE_TEXT_SHADOW_COLOR])
        else
          textpos.push([@trainer.name, WidescreenUI::LOAD_TEXT_PLAYER_NAME_POS[0], WidescreenUI::LOAD_TEXT_PLAYER_NAME_POS[1], :left, TEXT_COLOR, TEXT_SHADOW_COLOR])
        end
        
        mapname = pbGetMapNameFromId(@mapid)
        mapname.gsub!(/\\PN/, @trainer.name)
        textpos.push([mapname, WidescreenUI::LOAD_TEXT_MAP_NAME_POS[0], WidescreenUI::LOAD_TEXT_MAP_NAME_POS[1], :right, TEXT_COLOR, TEXT_SHADOW_COLOR])
        # --- FIN DE LA MODIFICACIÓN ---
      else
        textpos.push([@title, WidescreenUI::LOAD_TEXT_GENERAL_POS[0], WidescreenUI::LOAD_TEXT_GENERAL_POS[1], :left, TEXT_COLOR, TEXT_SHADOW_COLOR])
      end
      pbDrawTextPositions(self.bitmap, textpos)
    end
    @refreshing = false
  end
end

#-------------------------------------------------------------------------------
# Ajustes para la Pantalla de Carga (Load Screen)
#-------------------------------------------------------------------------------
class PokemonLoad_Scene
  def pbStartScene(commands, show_continue, trainer, stats, map_id)
    @commands = commands
    @sprites = {}
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99998
    addBackgroundOrColoredPlane(@sprites, "background", "Load/bg", Color.new(248, 248, 248), @viewport)
    y = WidescreenUI::LOAD_SCREEN_Y_OFFSET
    commands.length.times do |i|
      @sprites["panel#{i}"] = PokemonLoadPanel.new(
        i, commands[i], (show_continue) ? (i == 0) : false, trainer, stats, map_id, @viewport
      )
      @sprites["panel#{i}"].x = 48
      @sprites["panel#{i}"].y = y
      @sprites["panel#{i}"].pbRefresh
      y += (show_continue && i == 0) ? 224 : 48
    end
    @sprites["cmdwindow"] = Window_CommandPokemon.new([])
    @sprites["cmdwindow"].viewport = @viewport
    @sprites["cmdwindow"].visible  = false
  end

  # --- INICIO DE LA MODIFICACIÓN PARA POSICIÓN CONFIGURABLE ---
  def pbSetParty(trainer)
    return if !trainer || !trainer.party
    # Posición del sprite del jugador
    meta = GameData::PlayerMetadata.get(trainer.character_ID)
    if meta
      filename = pbGetPlayerCharset(meta.walk_charset, trainer, true)
      @sprites["player"] = TrainerWalkingCharSprite.new(filename, @viewport)
      if !@sprites["player"].bitmap
        raise _INTL("No se ha encontrado el charset del jugador {1} andando (archivo: \"{2}\").", trainer.character_ID, filename)
      end
      charwidth  = @sprites["player"].bitmap.width
      charheight = @sprites["player"].bitmap.height
      @sprites["player"].x = WidescreenUI::LOAD_PLAYER_POS[0] - (charwidth / 8)
      @sprites["player"].y = WidescreenUI::LOAD_PLAYER_POS[1] - (charheight / 8)
      @sprites["player"].z = 99999
    end
    # Posición de los iconos del equipo
    start_x = WidescreenUI::LOAD_PARTY_ICONS_START_POS[0]
    start_y = WidescreenUI::LOAD_PARTY_ICONS_START_POS[1]
    spacing_x = WidescreenUI::LOAD_PARTY_ICONS_SPACING[0]
    spacing_y = WidescreenUI::LOAD_PARTY_ICONS_SPACING[1]
    trainer.party.each_with_index do |pkmn, i|
      @sprites["party#{i}"] = PokemonIconSprite.new(pkmn, @viewport)
      @sprites["party#{i}"].setOffset(PictureOrigin::CENTER)
      @sprites["party#{i}"].x = start_x + (spacing_x * (i % 2))
      @sprites["party#{i}"].y = start_y + (spacing_y * (i / 2))
      @sprites["party#{i}"].z = 99999
    end
  end
  # --- FIN DE LA MODIFICACIÓN ---
end

#-------------------------------------------------------------------------------
# Ajustes para la Interfaz de Batalla Mejorada (Enhanced Battle UI)
#-------------------------------------------------------------------------------
class Battle::Scene
  # Se ajusta la posición vertical de la UI de información del combatiente.
  def pbUpdateBattlerInfo(battler, effects, idxEffect = 0)
    @enhancedUIOverlay.clear
    pbUpdateBattlerIcons
    return if @enhancedUIToggle != :battler
    xpos = WidescreenUI::BATTLE_UI_BASE_POS[0]
    ypos = WidescreenUI::BATTLE_UI_BASE_POS[1] + WidescreenUI::BATTLE_INFO_Y_OFFSET
    iconX = WidescreenUI::BATTLE_UI_ICON_POS[0]
    iconY = WidescreenUI::BATTLE_UI_ICON_POS[1]
    panelX = WidescreenUI::BATTLE_UI_PANEL_POS[0]
    #---------------------------------------------------------------------------
    # El resto del método original no se modifica, solo las variables de posición.
    # General UI elements.
    poke = (battler.opposes?) ? battler.displayPokemon : battler.pokemon
    level = (battler.isRaidBoss?) ? "???" : battler.level.to_s
    movename = (battler.lastMoveUsed) ? GameData::Move.get(battler.lastMoveUsed).name : "---"
    movename = movename[0..12] + "..." if movename.length > 16
    imagePos = [
      [@path + "info_bg", 0, 0],
      [@path + "info_bg_data", 0, 0],
      [@path + "info_level", xpos + WidescreenUI::BATTLE_GFX_LEVEL_POS[0], ypos + WidescreenUI::BATTLE_GFX_LEVEL_POS[1]]
    ]
    imagePos.push([@path + "info_gender", xpos + WidescreenUI::BATTLE_GFX_GENDER_POS[0], ypos + WidescreenUI::BATTLE_GFX_GENDER_POS[1], poke.gender * 22, 0, 22, 22]) if !battler.isRaidBoss?
    textPos  = [
      # Nombre del Pokémon
      [_INTL("{1}", poke.name), iconX + 82 + WidescreenUI::BATTLE_TEXT_NAME_OFFSET[0], iconY - 20 + WidescreenUI::BATTLE_TEXT_NAME_OFFSET[1], :center, BASE_DARK, SHADOW_DARK],
      # Nivel
      [_INTL("{1}", level), xpos + 62 + WidescreenUI::BATTLE_TEXT_LEVEL_OFFSET[0], ypos + 104 + WidescreenUI::BATTLE_TEXT_LEVEL_OFFSET[1], :left, BASE_LIGHT, SHADOW_LIGHT],
      # Último movimiento
      [_INTL("Usó: {1}", movename), xpos + 349 + WidescreenUI::BATTLE_TEXT_MOVE_OFFSET[0], ypos + 104 + WidescreenUI::BATTLE_TEXT_MOVE_OFFSET[1], :center, BASE_LIGHT, SHADOW_LIGHT],
      # Turno
      [_INTL("Turno {1}", @battle.turnCount + 1), Graphics.width - xpos - 32 + WidescreenUI::BATTLE_TEXT_TURN_OFFSET[0], ypos + 8 + WidescreenUI::BATTLE_TEXT_TURN_OFFSET[1], :center, BASE_DARK, SHADOW_DARK]
    ]
    #---------------------------------------------------------------------------
    # Battler icon.
    @battle.allBattlers.each do |b|
      @sprites["info_icon#{b.index}"].x = iconX
      @sprites["info_icon#{b.index}"].y = iconY
      @sprites["info_icon#{b.index}"].visible = (b.index == battler.index)
    end            
    #---------------------------------------------------------------------------
    # Owner
    if !battler.wild?
      imagePos.push([@path + "info_owner", xpos + WidescreenUI::BATTLE_GFX_OWNER_TAG_POS[0], ypos + WidescreenUI::BATTLE_GFX_OWNER_TAG_POS[1], 0, 20, 128, 20])
      textPos.push([@battle.pbGetOwnerFromBattlerIndex(battler.index).name, xpos + 32 + WidescreenUI::BATTLE_TEXT_OWNER_OFFSET[0], ypos + 8 + WidescreenUI::BATTLE_TEXT_OWNER_OFFSET[1], :center, BASE_DARK, SHADOW_DARK])
    end
    # Battler HP.
    if battler.hp > 0
      w = battler.hp * 96 / battler.totalhp.to_f
      w = 1 if w < 1
      w = ((w / 2).round) * 2
      hpzone = 0
      hpzone = 1 if battler.hp <= (battler.totalhp / 2).floor
      hpzone = 2 if battler.hp <= (battler.totalhp / 4).floor
      imagePos.push([@path + "info_hp", WidescreenUI::BATTLE_GFX_HP_BAR_POS[0], WidescreenUI::BATTLE_GFX_HP_BAR_POS[1], 0, hpzone * 6, w, 6])
    end
    # Battler status.
    if battler.status != :NONE
      iconPos = GameData::Status.get(battler.status).icon_position
      imagePos.push(["Graphics/UI/statuses", xpos + WidescreenUI::BATTLE_GFX_STATUS_POS[0], ypos + WidescreenUI::BATTLE_GFX_STATUS_POS[1], 0, iconPos * 16, 44, 16])
    end
    # Shininess
    imagePos.push(["Graphics/UI/shiny", xpos + WidescreenUI::BATTLE_GFX_SHINY_POS[0], ypos + WidescreenUI::BATTLE_GFX_SHINY_POS[1]]) if poke.shiny?
    #---------------------------------------------------------------------------
    # Battler info for player-owned Pokemon.
    if battler.pbOwnedByPlayer?
      imagePos.push(
        [@path + "info_owner", xpos + WidescreenUI::BATTLE_GFX_PLAYER_OWNER_POS[0], iconY + WidescreenUI::BATTLE_GFX_PLAYER_OWNER_POS[1], 0, 0, 128, 20],
        [@path + "info_cursor", panelX + WidescreenUI::BATTLE_GFX_ABILITY_CURSOR_POS[0], WidescreenUI::BATTLE_GFX_ABILITY_CURSOR_POS[1], 0, 0, 218, 26],
        [@path + "info_cursor", panelX + WidescreenUI::BATTLE_GFX_ITEM_CURSOR_POS[0], WidescreenUI::BATTLE_GFX_ITEM_CURSOR_POS[1], 0, 0, 218, 26]
      )
      textPos.push(
        # Habilidad
        [_INTL("Hab."), xpos + 349 + WidescreenUI::BATTLE_TEXT_ABILITY_OFFSET[0], ypos + 44 + WidescreenUI::BATTLE_TEXT_ABILITY_OFFSET[1], :center, BASE_LIGHT, SHADOW_LIGHT],
        [_INTL("{1}", battler.abilityName), xpos + 453 + WidescreenUI::BATTLE_TEXT_ABILITY_OFFSET[0], ypos + 44 + WidescreenUI::BATTLE_TEXT_ABILITY_OFFSET[1], :center, BASE_DARK, SHADOW_DARK],
        # Objeto
        [_INTL("Obj."), xpos + 349 + WidescreenUI::BATTLE_TEXT_ITEM_OFFSET[0], ypos + 68 + WidescreenUI::BATTLE_TEXT_ITEM_OFFSET[1], :center, BASE_LIGHT, SHADOW_LIGHT],
        [_INTL("{1}", battler.itemName), xpos + 453 + WidescreenUI::BATTLE_TEXT_ITEM_OFFSET[0], ypos + 68 + WidescreenUI::BATTLE_TEXT_ITEM_OFFSET[1], :center, BASE_DARK, SHADOW_DARK],
        # PS (numérico)
        [sprintf("%d/%d", battler.hp, battler.totalhp), iconX + 74 + WidescreenUI::BATTLE_TEXT_HP_OFFSET[0], iconY + 12 + WidescreenUI::BATTLE_TEXT_HP_OFFSET[1], :center, BASE_LIGHT, SHADOW_LIGHT]
      )
      # Fondo del texto de HP
      imagePos.push([@path + "info_cursor", WidescreenUI::BATTLE_GFX_HP_TEXT_BG_POS[0], WidescreenUI::BATTLE_GFX_HP_TEXT_BG_POS[1], 0, 0, 60, 20])
    end
    #---------------------------------------------------------------------------
    pbAddWildIconDisplay(xpos, ypos, battler, imagePos)
    # Modificación para pasar los desplazamientos de texto de estadísticas
    pbAddStatsDisplay(xpos, ypos, battler, imagePos, textPos, 0, 0)
    # Fin de la modificación
    pbDrawImagePositions(@enhancedUIOverlay, imagePos)
    pbDrawTextPositions(@enhancedUIOverlay, textPos)
    pbAddTypesDisplay(xpos, ypos, battler, poke)
    pbAddEffectsDisplay(xpos, ypos, panelX, effects, idxEffect)
  end
end

#-------------------------------------------------------------------------------
# Ajustes para la Interfaz de Batalla Mejorada (Continuación)
#-----------------------------------------------------------------------------
# Se modifica para aceptar desplazamientos de texto.
#-----------------------------------------------------------------------------
class Battle::Scene
  def pbAddStatsDisplay(xpos, ypos, battler, imagePos, textPos, x_offset = 0, y_offset = 0)
    [[:ATTACK,          _INTL("Ataque")],
     [:DEFENSE,         _INTL("Defensa")], 
     [:SPECIAL_ATTACK,  _INTL("At. Esp.")], 
     [:SPECIAL_DEFENSE, _INTL("Def. Esp.")], 
     [:SPEED,           _INTL("Velocidad")], 
     [:ACCURACY,        _INTL("Precisión")], 
     [:EVASION,         _INTL("Evasión")],
     _INTL("Críticos")
    ].each_with_index do |stat, i|
      if stat.is_a?(Array)
        # --- INICIO DE LA CORRECCIÓN ---
        # Se restaura la lógica para definir el color del texto de la estadística.
        color = SHADOW_LIGHT
        if battler.pbOwnedByPlayer?
          battler.pokemon.nature_for_stats.stat_changes.each do |s|
            if stat[0] == s[0]
              color = Color.new(136, 96, 72)  if s[1] > 0 # Red Nature text.
              color = Color.new(64, 120, 152) if s[1] < 0 # Blue Nature text.
            end
          end
        end
        # --- FIN DE LA CORRECCIÓN ---
        stat_x = x_offset + WidescreenUI::BATTLE_TEXT_STATS_OFFSETS[i][0]
        stat_y = y_offset + WidescreenUI::BATTLE_TEXT_STATS_OFFSETS[i][1]
        textPos.push([stat[1], xpos + 32 + stat_x, ypos + 138 + (i * 24) + stat_y, :left, BASE_LIGHT, color])
        stage = battler.stages[stat[0]]
      else
        stat_x = x_offset + WidescreenUI::BATTLE_TEXT_STATS_OFFSETS[i][0]
        stat_y = y_offset + WidescreenUI::BATTLE_TEXT_STATS_OFFSETS[i][1]
        textPos.push([stat, xpos + 32 + stat_x, ypos + 138 + (i * 24) + stat_y, :left, BASE_LIGHT, SHADOW_LIGHT])
        stage = [battler.effects[PBEffects::FocusEnergy], 3].min
      end
      # ... (código original sin cambios)
      if stage != 0
        arrow = (stage > 0) ? 0 : 18
        stage.abs.times do |t| 
          # --- INICIO DE LA MODIFICACIÓN PARA CAMBIOS DE STATS ---
          imagePos.push([@path + "info_stats", xpos + WidescreenUI::BATTLE_GFX_STATS_CHANGE_POS[0] + (t * 18), ypos + WidescreenUI::BATTLE_GFX_STATS_CHANGE_POS[1] + (i * 24), arrow, 0, 18, 18])
          # --- FIN DE LA MODIFICACIÓN ---
        end
      end
    end
  end
end

#-------------------------------------------------------------------------------
# Ajustes para la Interfaz de Batalla Mejorada (Efectos)
#-------------------------------------------------------------------------------
class Battle::Scene
  alias widescreen_pbAddEffectsDisplay pbAddEffectsDisplay unless method_defined?(:widescreen_pbAddEffectsDisplay)
  def pbAddEffectsDisplay(xpos, ypos, panelX, effects, idxEffect)
    # --- INICIO DE LA MODIFICACIÓN PARA POSICIÓN CONFIGURABLE ---
    # Aplicar desplazamientos desde el módulo de configuración
    xpos += WidescreenUI::BATTLE_GFX_EFFECTS_POS[0]
    ypos += WidescreenUI::BATTLE_GFX_EFFECTS_POS[1]
    panelX += WidescreenUI::BATTLE_GFX_EFFECTS_POS[0]

    # Llamada al método original con las nuevas coordenadas
    widescreen_pbAddEffectsDisplay(xpos, ypos, panelX, effects, idxEffect)

    # Sobrescribir la posición de los sliders si existen
    if @sprites["info_slider_base"] && @sprites["info_slider"]
      @sprites["info_slider_base"].x = WidescreenUI::BATTLE_GFX_EFFECTS_SLIDER_BASE_POS[0]
      @sprites["info_slider_base"].y = WidescreenUI::BATTLE_GFX_EFFECTS_SLIDER_BASE_POS[1]
      
      # Calcula la posición Y del slider dinámicamente
      y_slider = WidescreenUI::BATTLE_GFX_EFFECTS_SLIDER_POS[1]
      if effects.length > 1
        y_slider += (idxEffect * 102 / (effects.length - 1)).round
      end
      @sprites["info_slider"].x = WidescreenUI::BATTLE_GFX_EFFECTS_SLIDER_POS[0]
      @sprites["info_slider"].y = y_slider
    end
    # --- FIN DE LA MODIFICACIÓN ---
  end
end

#-------------------------------------------------------------------------------
# Ajustes para la Interfaz de Batalla Mejorada (Tipos)
#-------------------------------------------------------------------------------
class Battle::Scene
 def pbAddTypesDisplay(xpos, ypos, battler, poke)
   #---------------------------------------------------------------------------
   # Gets display types (considers Illusion)
   illusion = battler.effects[PBEffects::Illusion] && !battler.pbOwnedByPlayer?
   if battler.tera?
     displayTypes = (illusion) ? poke.types.clone : battler.pbPreTeraTypes
   elsif illusion
     displayTypes = poke.types.clone
     displayTypes.push(battler.effects[PBEffects::ExtraType]) if battler.effects[PBEffects::ExtraType]
   else
     displayTypes = battler.pbTypes(true)
   end
   #---------------------------------------------------------------------------
   # Displays the "???" type on newly encountered species, or battlers with no typing.
   if Settings::SHOW_TYPE_EFFECTIVENESS_FOR_NEW_SPECIES
     unknown_species = false
   else
     unknown_species = !(
       !@battle.internalBattle ||
       battler.pbOwnedByPlayer? ||
       $player.pokedex.owned?(poke.species) ||
       $player.pokedex.battled_count(poke.species) > 0
     )
   end
   displayTypes = [:QMARKS] if unknown_species || displayTypes.empty?
   #---------------------------------------------------------------------------
   # Draws each display type. Maximum of 3 types.
   typeY = (displayTypes.length >= 3) ? ypos + 6 : ypos + 34
   typebitmap = AnimatedBitmap.new(_INTL("Graphics/UI/types"))
   displayTypes.each_with_index do |type, i|
     break if i > 2
     type_number = GameData::Type.get(type).icon_position
     type_rect = Rect.new(0, type_number * 28, 64, 28)
     @enhancedUIOverlay.blt(xpos + 190 + 14, typeY + (i * 30), typebitmap.bitmap, type_rect)
   end
   #---------------------------------------------------------------------------
   # Draws Tera type.
   if battler.tera?
     showTera = true
   else
     showTera = defined?(battler.tera_type) && battler.pokemon.terastal_able?
     showTera = ((@battle.internalBattle) ? !battler.opposes? : true) if showTera
   end
   if showTera
     pkmn = (illusion) ? poke : battler
     pbDrawImagePositions(@enhancedUIOverlay, [[@path + "info_extra", xpos + 182, ypos + 95]])
     pbDisplayTeraType(pkmn, @enhancedUIOverlay, xpos + 186, ypos + 97, true)
   end
 end
end

#-------------------------------------------------------------------------------
# Ajustes para la Move Info UI
#-------------------------------------------------------------------------------
class Battle::Scene
 alias widescreen_pbUpdateMoveInfoWindow pbUpdateMoveInfoWindow unless method_defined?(:widescreen_pbUpdateMoveInfoWindow)
 def pbUpdateMoveInfoWindow(battler, specialAction, cw)
   @enhancedUIOverlay.clear
   return if @enhancedUIToggle != :move
   xpos = WidescreenUI::MOVE_UI_X_OFFSET
   ypos = 94 + WidescreenUI::MOVE_UI_Y_OFFSET
   move = battler.moves[cw.index]
   if battler.dynamax? || specialAction == :dynamax && cw.mode == 2
     move = move.convert_dynamax_move(battler, @battle)
   end
   powBase   = accBase   = priBase   = effBase   = BASE_LIGHT
   powShadow = accShadow = priShadow = effShadow = SHADOW_LIGHT
   basePower = calcPower = power = move.power
   category = move.category
   type = move.pbCalcType(battler)
   terastal = battler.tera? || (specialAction == :tera && cw.teraType > 0)
   #---------------------------------------------------------------------------
   # Gets move type and category (for display purposes).
   case move.function_code
   when "CategoryDependsOnHigherDamageTera",
        "TerapagosCategoryDependsOnHigherDamage"
     if terastal
       case move.function_code
       when "CategoryDependsOnHigherDamageTera"
         type = battler.tera_type
         basePower = calcPower = power = 100
       when "TerapagosCategoryDependsOnHigherDamage"
         type = :STELLAR if battler.isSpecies?(:TERAPAGOS)
       end
       realAtk, realSpAtk = battler.getOffensiveStats
       category = (realAtk > realSpAtk) ? 0 : 1
     else
       type = move.type
       category = move.calcCategory
     end
   when "CategoryDependsOnHigherDamagePoisonTarget",
        "CategoryDependsOnHigherDamageIgnoreTargetAbility"
     move.pbOnStartUse(battler, [battler.pbDirectOpposing])
     category = move.calcCategory
   end
   #---------------------------------------------------------------------------
   # Draws images.
   typenumber = GameData::Type.get(type).icon_position
   bgnumber = (Settings::USE_MOVE_TYPE_BACKGROUNDS) ? typenumber + 1 : 0
   imagePos = [
     [@path + "move_bg",      xpos,       ypos,     0, bgnumber * 164, 640, 164],
     ["Graphics/UI/types",    xpos + WidescreenUI::MOVE_GFX_TYPE_POS[0], ypos + WidescreenUI::MOVE_GFX_TYPE_POS[1], 0, typenumber * 28, 64, 28],
     ["Graphics/UI/category", xpos + WidescreenUI::MOVE_GFX_CATEGORY_POS[0], ypos + WidescreenUI::MOVE_GFX_CATEGORY_POS[1], 0, category * 28, 64, 28]
   ]
   pbDrawMoveFlagIcons(xpos, ypos, move, imagePos)
   pbDrawTypeEffectiveness(xpos, ypos, move, type, imagePos)
   pbDrawImagePositions(@enhancedUIOverlay, imagePos)
   #---------------------------------------------------------------------------
   # Move damage calculations (for display purposes).
   if move.damagingMove?
     if terastal
       if battler.typeTeraBoosted?(type, true)
         bonus = (battler.tera_type == :STELLAR) ? 1.2 : 1.5
         stab = (battler.types.include?(type)) ? 2 : bonus
       else
         stab = (battler.types.include?(type)) ? 1.5 : 1
       end
     else
       stab = (battler.pbHasType?(type)) ? 1.5 : 1
     end
     stab = 1 if defined?(move.pbFixedDamage(battler, battler.pbDirectOpposing))
     hidePower = false
     case move.function_code
     when "ThrowUserItemAtTarget"                     # Fling
       hidePower = true if !battler.item
     when "TypeAndPowerDependOnUserBerry"             # Natural Gift
       hidePower = true if !battler.item || !battler.item.is_berry?
     when "PursueSwitchingFoe",                       # Pursuit
          "RemoveTargetItem",                         # Knock Off
          "HitOncePerUserTeamMember",                 # Beat Up
          "DoublePowerIfTargetActed",                 # Payback
          "DoublePowerIfTargetNotActed",              # Bolt Beak, Fishious Rend
          "PowerHigherWithTargetHP",                  # Crush Grip, Wring Out
          "PowerHigherWithTargetHP100PowerRange",     # Hard Press
          "HitThreeTimesPowersUpWithEachHit",         # Triple Kick
          "PowerHigherWithTargetWeight",              # Low Kick, Grass Knot
          "PowerHigherWithUserFasterThanTarget",      # Electro Ball
          "PowerHigherWithTargetFasterThanUser",      # Gyro Ball
          "FixedDamageUserLevelRandom",               # Psywave
          "RandomlyDamageOrHealTarget",               # Present
          "RandomlyDealsDoubleDamage",                # Fickle Beam
          "RandomPowerDoublePowerIfTargetUnderground" # Magnitude
       hidePower = true if calcPower == 1
     end
     if !hidePower
       calcPower = move.pbBaseDamage(basePower, battler, battler.pbDirectOpposing)
       calcPower = move.pbModifyDamage(calcPower, battler, battler.pbDirectOpposing)
       calcPower = move.pbBaseDamageTera(calcPower, battler, type, true) if terastal
     end
     hidePower = true if calcPower == 1
     powerDiff = (move.function_code == "PowerHigherWithUserHP") ? calcPower - basePower : basePower - calcPower
     calcPower *= stab
     power = (calcPower >= powerDiff) ? calcPower : basePower * stab
   end
   #---------------------------------------------------------------------------
   # Final move attribute calculations.
   acc = move.accuracy
   pri = move.priority
   case move.function_code
   when "ParalyzeFlinchTarget", "BurnFlinchTarget", "FreezeFlinchTarget"
     chance = 10
   when "LowerTargetDefense1FlinchTarget"
     chance = 50
   else
     chance = move.addlEffect
   end
   baseChance = chance
   showTera = terastal && battler.typeTeraBoosted?(type, true)
   bonus, power, acc, pri, chance = pbGetFinalModifiers(
     battler, move, type, basePower, power, acc, pri, chance, showTera)
   calcPower = power if power > basePower
   if power > 1
     if calcPower > basePower
       powBase, powShadow = BASE_RAISED, SHADOW_RAISED
     elsif power < (basePower * stab).floor
       powBase, powShadow = BASE_LOWERED, SHADOW_LOWERED
     end
   end
   if acc > 0
     if acc > move.accuracy
       accBase, accShadow = BASE_RAISED, SHADOW_RAISED
     elsif acc < move.accuracy
       accBase, accShadow = BASE_LOWERED, SHADOW_LOWERED
     end
   end
   if pri != 0
     if pri > move.priority
       priBase, priShadow = BASE_RAISED, SHADOW_RAISED
     elsif pri < move.priority
       priBase, priShadow = BASE_LOWERED, SHADOW_LOWERED
     end
   end
   if chance > 0
     if chance > baseChance
       effBase, effShadow = BASE_RAISED, SHADOW_RAISED
     elsif chance < baseChance
       effBase, effShadow = BASE_LOWERED, SHADOW_LOWERED
     end
   end
   #---------------------------------------------------------------------------
   # Draws text.
   textPos = []
   displayPower    = (power  == 0) ? "---" : (hidePower) ? "???" : power.ceil.to_s
   displayAccuracy = (acc    == 0) ? "---" : acc.ceil.to_s
   displayPriority = (pri    == 0) ? "---" : (pri > 0) ? "+" + pri.to_s : pri.to_s
   displayChance   = (chance == 0) ? "---" : chance.ceil.to_s + "%"
   textPos.push(
     [move.name,       xpos + WidescreenUI::MOVE_TEXT_NAME_POS[0],  ypos + WidescreenUI::MOVE_TEXT_NAME_POS[1], :left,   BASE_LIGHT, SHADOW_LIGHT],
     [_INTL("Poder:"),    xpos + WidescreenUI::MOVE_TEXT_POWER_POS[0], ypos + WidescreenUI::MOVE_TEXT_POWER_POS[1], :left,   BASE_LIGHT, SHADOW_LIGHT],
     [displayPower,    xpos + WidescreenUI::MOVE_TEXT_POWER_POS[0] + 70, ypos + WidescreenUI::MOVE_TEXT_POWER_POS[1], :center, powBase,    powShadow],
     [_INTL("Prec.:"),    xpos + WidescreenUI::MOVE_TEXT_ACCURACY_POS[0], ypos + WidescreenUI::MOVE_TEXT_ACCURACY_POS[1], :left,   BASE_LIGHT, SHADOW_LIGHT],
     [displayAccuracy, xpos + WidescreenUI::MOVE_TEXT_ACCURACY_POS[0] + 43, ypos + WidescreenUI::MOVE_TEXT_ACCURACY_POS[1], :center, accBase,    accShadow],
     [_INTL("Prior:"),    xpos + WidescreenUI::MOVE_TEXT_PRIORITY_POS[0], ypos + WidescreenUI::MOVE_TEXT_PRIORITY_POS[1], :left,   BASE_LIGHT, SHADOW_LIGHT],
     [displayPriority, xpos + WidescreenUI::MOVE_TEXT_PRIORITY_POS[0] + 34, ypos + WidescreenUI::MOVE_TEXT_PRIORITY_POS[1], :center, priBase,    priShadow],
     [_INTL("Efecto:"),    xpos + WidescreenUI::MOVE_TEXT_EFFECT_POS[0], ypos + WidescreenUI::MOVE_TEXT_EFFECT_POS[1], :left,   BASE_LIGHT, SHADOW_LIGHT],
     [displayChance,   xpos + WidescreenUI::MOVE_TEXT_EFFECT_POS[0] + 48, ypos + WidescreenUI::MOVE_TEXT_EFFECT_POS[1], :center, effBase,    effShadow]
   )
   textPos.push([bonus[0], xpos + WidescreenUI::MOVE_TEXT_BONUS_POS[0], ypos + WidescreenUI::MOVE_TEXT_BONUS_POS[1], :left, bonus[1], bonus[2], :outline]) if bonus
   pbDrawTextPositions(@enhancedUIOverlay, textPos)
   drawTextEx(@enhancedUIOverlay, xpos + WidescreenUI::MOVE_TEXT_DESCRIPTION_POS[0], ypos + WidescreenUI::MOVE_TEXT_DESCRIPTION_POS[1], Graphics.width - 12, 2,
     GameData::Move.get(move.id).description, BASE_LIGHT, SHADOW_LIGHT)
 end
end

#-------------------------------------------------------------------------------
# Ajustes para la Pantalla de Resumen (Summary Screen)
#-------------------------------------------------------------------------------
class PokemonSummary_Scene
  # Se ajusta la posición vertical del icono del objeto.
  def pbStartScene(party, partyindex, inbattle = false, page=1, allow_learn_moves = true)
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @party      = party
    @partyindex = partyindex
    @pokemon    = @party[@partyindex]
    @inbattle   = inbattle
    @allow_learn_moves = allow_learn_moves
    @page = page
    @typebitmap    = AnimatedBitmap.new(_INTL("Graphics/UI/types"))
    @markingbitmap = AnimatedBitmap.new("Graphics/UI/Summary/markings")
    @sprites = {}
    @sprites["background"] = IconSprite.new(0, 0, @viewport)
    @sprites["pokemon"] = PokemonSprite.new(@viewport)
    @sprites["pokemon"].setOffset(PictureOrigin::CENTER)
    @sprites["pokemon"].x = 104
    @sprites["pokemon"].y = 206
    @sprites["pokemon"].setPokemonBitmap(@pokemon)
    @sprites["pokeicon"] = PokemonIconSprite.new(@pokemon, @viewport)
    @sprites["pokeicon"].setOffset(PictureOrigin::CENTER)
    @sprites["pokeicon"].x       = 36
    @sprites["pokeicon"].y       = 92
    @sprites["pokeicon"].visible = false
    # Se ajusta la posición Y del icono del objeto para que no se corte.
    @sprites["itemicon"] = ItemIconSprite.new(30, WidescreenUI::SUMMARY_ITEM_Y_OFFSET, @pokemon.item_id, @viewport)
    @sprites["itemicon"].blankzero = true
    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    @sprites["movepresel"] = MoveSelectionSprite.new(@viewport)
    @sprites["movepresel"].visible     = false
    @sprites["movepresel"].preselected = true
    @sprites["movesel"] = MoveSelectionSprite.new(@viewport)
    @sprites["movesel"].visible = false
    @sprites["ribbonpresel"] = RibbonSelectionSprite.new(@viewport)
    @sprites["ribbonpresel"].visible     = false
    @sprites["ribbonpresel"].preselected = true
    @sprites["ribbonsel"] = RibbonSelectionSprite.new(@viewport)
    @sprites["ribbonsel"].visible = false
    @sprites["uparrow"] = AnimatedSprite.new("Graphics/UI/up_arrow", 8, 28, 40, 2, @viewport)
    @sprites["uparrow"].x = 350
    @sprites["uparrow"].y = 56
    @sprites["uparrow"].play
    @sprites["uparrow"].visible = false
    @sprites["downarrow"] = AnimatedSprite.new("Graphics/UI/down_arrow", 8, 28, 40, 2, @viewport)
    @sprites["downarrow"].x = 350
    @sprites["downarrow"].y = 260
    @sprites["downarrow"].play
    @sprites["downarrow"].visible = false
    @sprites["markingbg"] = IconSprite.new(260, 88, @viewport)
    @sprites["markingbg"].setBitmap("Graphics/UI/Summary/overlay_marking")
    @sprites["markingbg"].visible = false
    @sprites["markingoverlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    @sprites["markingoverlay"].visible = false
    pbSetSystemFont(@sprites["markingoverlay"].bitmap)
    @sprites["markingsel"] = IconSprite.new(0, 0, @viewport)
    @sprites["markingsel"].setBitmap("Graphics/UI/Summary/cursor_marking")
    @sprites["markingsel"].src_rect.height = @sprites["markingsel"].bitmap.height / 2
    @sprites["markingsel"].visible = false
    @sprites["messagebox"] = Window_AdvancedTextPokemon.new("")
    @sprites["messagebox"].viewport       = @viewport
    @sprites["messagebox"].visible        = false
    @sprites["messagebox"].letterbyletter = true
    pbBottomLeftLines(@sprites["messagebox"], 2)
    @nationalDexList = [:NONE]
    GameData::Species.each_species { |s| @nationalDexList.push(s.species) }
    drawPage(@page)
    pbFadeInAndShow(@sprites) { pbUpdate }
  end
end

#-------------------------------------------------------------------------------
# Ajustes para la Pantalla de Resumen (Continuación)
#-------------------------------------------------------------------------------
class PokemonSummary_Scene
  NAME_BASE_COLOR = Color.new(248, 248, 248)
  NAME_SHADOW_COLOR = Color.new(104, 104, 104)
  TEXT_BASE_COLOR = Color.new(248, 248, 248)
  TEXT_SHADOW_COLOR = Color.new(104, 104, 104)

  # alias widescreen_drawPage drawPage unless method_defined?(:widescreen_drawPage)
  # def drawPage(page)
  #   widescreen_drawPage(page)
  #   # ... (código original de drawPage)
  #   # Al final del método, justo antes del "end", añade esto:
  #   
  #   # --- INICIO DE LA MODIFICACIÓN PARA TEXTO CONFIGURABLE ---
  #   # Redibuja el nombre del Pokémon y el objeto usando las coordenadas del módulo.
  #   overlay = @sprites["overlay"].bitmap
  #   
  #   # Nombre del Pokémon
  #   pokename_pos = WidescreenUI::SUMMARY_TEXT_POKENAME_POS
  #   textpos = [[_INTL("{1}", @pokemon.name), pokename_pos[0], pokename_pos[1], 0, NAME_BASE_COLOR, NAME_SHADOW_COLOR]]
  #   
  #   # Nivel del Pokémon
  #   level_pos = WidescreenUI::SUMMARY_TEXT_LEVEL_POS
  #   level_text = _INTL("Nv. {1}", @pokemon.level)
  #   textpos.push([level_text, level_pos[0], level_pos[1], 0, TEXT_BASE_COLOR, TEXT_SHADOW_COLOR])
  #
  #   # Nombre del objeto
  #   if @pokemon.hasItem?
  #     itemname_pos = WidescreenUI::SUMMARY_TEXT_ITEM_POS
  #     textpos.push([_INTL("{1}", @pokemon.itemName), itemname_pos[0], itemname_pos[1], 0, TEXT_BASE_COLOR, TEXT_SHADOW_COLOR])
  #   end
  #   pbDrawTextPositions(overlay, textpos)
  #   # --- FIN DE LA MODIFICACIÓN ---
  # end
end

#===============================================================================
# Marcadores de posición para futuras adaptaciones
#===============================================================================

#-------------------------------------------------------------------------------
# Ajustes para la Pokédex (Ejemplo)
#-------------------------------------------------------------------------------
# Descomenta y adapta esta sección cuando tengas el script de la Pokédex.
#
# class PokemonPokedexList_Scene
#   def pbStartScene
#     # ... código original ...
#     # Ejemplo de cómo usar la constante:
#     @sprites["list"].y = WidescreenUI::POKEDEX_LIST_Y_OFFSET
#     # ... resto del código ...
#   end
# end

#-------------------------------------------------------------------------------
# Ajustes para Movimientos de Campo (Ejemplo)
#-------------------------------------------------------------------------------
# Descomenta y adapta esta sección si tienes una UI para movimientos de campo.
#
# class FieldMove_Scene
#   def pbStartScene
#     # ... tu código aquí, usando WidescreenUI::FIELD_MOVE_Y_OFFSET ...
#   end
# end

#===============================================================================
# Traducciones para la Interfaz de Batalla Mejorada
#===============================================================================
class Battle::Scene
  alias :widescreen_pbGetDisplayEffects :pbGetDisplayEffects
  def pbGetDisplayEffects(battler)
    display_effects = widescreen_pbGetDisplayEffects(battler)
    weather = battler.effectiveWeather
    if weather != :None
      name = GameData::BattleWeather.get(weather).name
      desc = ""
      case weather
      when :Sun         then desc = _INTL("Potencia los movimientos de Fuego y debilita los de Agua.")
      when :HarshSun    then desc = _INTL("Potencia los movimientos de Fuego y anula los de Agua.")
      when :Rain        then desc = _INTL("Potencia los movimientos de Agua y debilita los de Fuego.")
      when :HeavyRain   then desc = _INTL("Potencia los movimientos de Agua y anula los de Fuego.")
      when :Snow        then desc = _INTL("Sube la Defensa de los Pokémon de tipo Hielo. Ventisca siempre acierta.")
      when :Sandstorm   then desc = _INTL("Sube la Def. Esp. de los tipo Roca. Daña si no es Roca/Tierra/Acero.")
      when :StrongWinds then desc = _INTL("Los Pokémon de tipo Volador no recibirán daño supereficaz.")
      when :ShadowSky   then desc = _INTL("Potencia los movimientos Siniestros. Daña a los Pokémon no Siniestros.")
      end
      display_effects.each do |effect|
        effect[2] = desc if effect[0] == name && !desc.empty?
      end
    end
    return display_effects
  end
end
