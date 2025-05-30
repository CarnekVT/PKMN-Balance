#===============================================================================
#
#===============================================================================
def pbDefaultMap
  return $game_map.map_id if $game_map
  return $data_system.edit_map_id if $data_system
  return 0
end

def pbWarpToMap
  mapid = pbListScreen(_INTL("SALTAR A MAPA"), MapLister.new(pbDefaultMap))
  if mapid > 0
    map = Game_Map.new
    map.setup(mapid)
    success = false
    x = 0
    y = 0
    100.times do
      x = rand(map.width)
      y = rand(map.height)
      next if !map.passableStrict?(x, y, 0, $game_player)
      blocked = false
      map.events.each_value do |event|
        if event.at_coordinate?(x, y) && !event.through && event.character_name != ""
          blocked = true
        end
      end
      next if blocked
      success = true
      break
    end
    if !success
      x = rand(map.width)
      y = rand(map.height)
    end
    return [mapid, x, y]
  end
  return nil
end

#===============================================================================
# Debug Variables screen
#===============================================================================
class SpriteWindow_DebugVariables < Window_DrawableCommand
  attr_reader :mode

  def initialize(viewport)
    super(0, 0, Graphics.width, Graphics.height, viewport)
  end

  def itemCount
    return (@mode == 0) ? $data_system.switches.size - 1 : $data_system.variables.size - 1
  end

  def mode=(mode)
    @mode = mode
    refresh
  end

  def shadowtext(x, y, w, h, t, align = 0, colors = 0)
    width = self.contents.text_size(t).width
    case align
    when 1   # Right aligned
      x += (w - width)
    when 2   # Centre aligned
      x += (w / 2) - (width / 2)
    end
    y += 8   # TEXT OFFSET
    base = Color.new(96, 96, 96)
    case colors
    when 1   # Red
      base = Color.new(168, 48, 56)
    when 2   # Green
      base = Color.new(0, 144, 0)
    end
    pbDrawShadowText(self.contents, x, y, [width, w].max, h, t, base, Color.new(208, 208, 200))
  end

  def drawItem(index, _count, rect)
    pbSetNarrowFont(self.contents)
    colors = 0
    codeswitch = false
    if @mode == 0
      name = $data_system.switches[index + 1]
      codeswitch = (name[/^s\:/])
      if codeswitch
        code = $~.post_match
        code_parts = code.split(/[(\[=<>. ]/)
        code_parts[0].strip!
        code_parts[0].gsub!(/^\s*!/, "")
        val = nil
        if code_parts[0][0][/[a-z]/i]
          if code_parts[0][0].upcase == code_parts[0][0] &&
             (Kernel.const_defined?(code_parts[0]) rescue false)
            val = (eval(code) rescue nil)   # Code starts with a class/method name
          elsif code_parts[0][0].downcase == code_parts[0][0] &&
                !(Interpreter.method_defined?(code_parts[0].to_sym) rescue false) &&
                !(Game_Event.method_defined?(code_parts[0].to_sym) rescue false)
            val = (eval(code) rescue nil)   # Code starts with a method name (that isn't in Interpreter/Game_Event)
          end
        else
          # Code doesn't start with a letter, probably $, just evaluate it
          val = (eval(code) rescue nil)
        end
      else
        val = $game_switches[index + 1]
      end
      if val.nil?
        status = "[-]"
        colors = 0
        codeswitch = true
      elsif val   # true
        status = "[ON]"
        colors = 2
      else   # false
        status = "[OFF]"
        colors = 1
      end
    else
      name = $data_system.variables[index + 1]
      status = $game_variables[index + 1].to_s
      status = "\"__\"" if nil_or_empty?(status)
    end
    name ||= ""
    id_text = sprintf("%04d:", index + 1)
    rect = drawCursor(index, rect)
    totalWidth = rect.width
    idWidth     = totalWidth * 15 / 100
    nameWidth   = totalWidth * 65 / 100
    statusWidth = totalWidth * 20 / 100
    self.shadowtext(rect.x, rect.y, idWidth, rect.height, id_text)
    self.shadowtext(rect.x + idWidth, rect.y, nameWidth, rect.height, name, 0, (codeswitch) ? 1 : 0)
    self.shadowtext(rect.x + idWidth + nameWidth, rect.y, statusWidth, rect.height, status, 1, colors)
  end
end

#===============================================================================
#
#===============================================================================
def pbDebugSetVariable(id, diff)
  $game_variables[id] = 0 if $game_variables[id].nil?
  if $game_variables[id].is_a?(Numeric)
    pbPlayCursorSE
    $game_variables[id] = [$game_variables[id] + diff, 99_999_999].min
    $game_variables[id] = [$game_variables[id], -99_999_999].max
    $game_map.need_refresh = true
  end
end

def pbDebugVariableScreen(id)
  case $game_variables[id]
  when Numeric
    value = $game_variables[id]
    params = ChooseNumberParams.new
    params.setDefaultValue(value)
    params.setMaxDigits(8)
    params.setNegativesAllowed(true)
    value = pbMessageChooseNumber(_INTL("Setea la variable {1}.", id), params)
    $game_variables[id] = [value, 99_999_999].min
    $game_variables[id] = [$game_variables[id], -99_999_999].max
    $game_map.need_refresh = true
  when String
    value = pbMessageFreeText(_INTL("Setea la variable {1}.", id),
                              $game_variables[id], false, 250, Graphics.width)
    $game_variables[id] = value
    $game_map.need_refresh = true
  end
end

def pbDebugVariables(mode)
  viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
  viewport.z = 99999
  sprites = {}
  sprites["right_window"] = SpriteWindow_DebugVariables.new(viewport)
  right_window = sprites["right_window"]
  right_window.mode     = mode
  right_window.active   = true
  loop do
    Graphics.update
    Input.update
    pbUpdateSpriteHash(sprites)
    if Input.trigger?(Input::BACK)
      pbPlayCancelSE
      break
    end
    current_id = right_window.index + 1
    case mode
    when 0   # Switches
      if Input.trigger?(Input::USE)
        pbPlayDecisionSE
        $game_switches[current_id] = !$game_switches[current_id]
        right_window.refresh
        $game_map.need_refresh = true
      end
    when 1   # Variables
      if Input.repeat?(Input::LEFT)
        pbDebugSetVariable(current_id, -1)
        right_window.refresh
      elsif Input.repeat?(Input::RIGHT)
        pbDebugSetVariable(current_id, 1)
        right_window.refresh
      elsif Input.trigger?(Input::ACTION)
        case $game_variables[current_id]
        when 0
          $game_variables[current_id] = ""
        when ""
          $game_variables[current_id] = 0
        else
          case $game_variables[current_id]
          when Numeric
            $game_variables[current_id] = 0
          when String
            $game_variables[current_id] = ""
          end
        end
        right_window.refresh
        $game_map.need_refresh = true
      elsif Input.trigger?(Input::USE)
        pbPlayDecisionSE
        pbDebugVariableScreen(current_id)
        right_window.refresh
      end
    end
  end
  pbDisposeSpriteHash(sprites)
  viewport.dispose
end

#===============================================================================
# Debug Day Care screen
#===============================================================================
def pbDebugDayCare
  day_care = $PokemonGlobal.day_care
  cmd_window = Window_CommandPokemonEx.newEmpty(0, 0, Graphics.width, Graphics.height)
  commands = []
  cmd = 0
  compat = 0
  need_refresh = true
  loop do
    if need_refresh
      commands.clear
      day_care.slots.each_with_index do |slot, i|
        if slot.filled?
          pkmn = slot.pokemon
          msg = _INTL("{1} ({2})", pkmn.name, pkmn.speciesName)
          if pkmn.male?
            msg += ", ♂"
          elsif pkmn.female?
            msg += ", ♀"
          end
          if slot.level_gain > 0
            msg += ", " + _INTL("Nv.{1} (+{2})", pkmn.level, slot.level_gain)
          else
            msg += ", " + _INTL("Nv.{1}", pkmn.level)
          end
          commands.push(_INTL("[Slot {1}] {2}", i, msg))
        else
          commands.push(_INTL("[Slot {1}] Vacío", i))
        end
      end
      compat = $PokemonGlobal.day_care.get_compatibility
      if day_care.egg_generated
        commands.push(_INTL("[Huevo disponible]"))
      elsif compat > 0
        commands.push(_INTL("[Puede producir un Huevo]"))
      else
        commands.push(_INTL("[No puede criar]"))
      end
      commands.push(_INTL("[Pasos para el siguiente ciclo: {1}]", 256 - day_care.step_counter))
      cmd_window.commands = commands
      need_refresh = false
    end
    cmd = pbCommands2(cmd_window, commands, -1, cmd, true)
    break if cmd < 0
    if cmd == commands.length - 2   # Egg
      compat = $PokemonGlobal.day_care.get_compatibility
      if compat == 0
        pbMessage(_INTL("El Pokémon no pueden criar."))
      else
        msg = _INTL("El Pokémon puede criar (compatibilidad = {1}).", compat)
        # Show compatibility
        if day_care.egg_generated
          case pbMessage("\\ts[]" + msg,
                         [_INTL("Recoger Huevo"), _INTL("Eliminar Huevo"), _INTL("Cancelar")], 3)
          when 0   # Collect egg
            if $player.party_full?
              pbMessage(_INTL("El equipo está lleno, no se puede recoger el Huevo."))
            else
              DayCare.collect_egg
              pbMessage(_INTL("Has recogido el huevo {1}.", $player.last_party.speciesName))
              need_refresh = true
            end
          when 1   # Clear egg
            day_care.egg_generated = false
            need_refresh = true
          end
        else
          case pbMessage("\\ts[]" + msg, [_INTL("Hacer Huevo disponible"), _INTL("Cancelar")], 2)
          when 0   # Make egg available
            day_care.egg_generated = true
            need_refresh = true
          end
        end
      end
    elsif cmd == commands.length - 1   # Steps to next cycle
      case pbMessage("\\ts[]" + _INTL("¿Cambiar el número de pasos al siguiente ciclo?"),
                     [_INTL("Setear a 1"), _INTL("Setear a 256"), _INTL("Setear a otro valor"), _INTL("Cancelar")], 4)
      when 0   # Set to 1
        day_care.step_counter = 255
        need_refresh = true
      when 1   # Set to 256
        day_care.step_counter = 0
        need_refresh = true
      when 2   # Set to other value
        params = ChooseNumberParams.new
        params.setDefaultValue(day_care.step_counter)
        params.setRange(1, 256)
        new_counter = pbMessageChooseNumber(_INTL("Setea los pasos para el siguiente ciclo (1-256)."), params)
        if new_counter != 256 - day_care.step_counter
          day_care.step_counter = 256 - new_counter
          need_refresh = true
        end
      end
    else   # Slot
      slot = day_care[cmd]
      if slot.filled?
        pkmn = slot.pokemon
        msg = _INTL("Coste: ${1}", slot.cost)
        if pkmn.level < GameData::GrowthRate.max_level
          end_exp = pkmn.growth_rate.minimum_exp_for_level(pkmn.level + 1)
          msg += "\\n" + _INTL("Pasos para el siguiente nivel: {1}", end_exp - pkmn.exp)
        end
        # Show level change and cost
        case pbMessage("\\ts[]" + msg,
                       [_INTL("Datos"), _INTL("Sacar"), _INTL("Cancelar")], 3)
        when 0   # Summary
          pbFadeOutIn do
            scene = PokemonSummary_Scene.new
            screen = PokemonSummaryScreen.new(scene, false)
            screen.pbStartScreen([pkmn], 0)
            need_refresh = true
          end
        when 1   # Withdraw
          if $player.party_full?
            pbMessage(_INTL("El equipo está lleno, no se puede sacar al Pokémon."))
          else
            $player.party.push(pkmn)
            slot.reset
            day_care.reset_egg_counters
            need_refresh = true
          end
        end
      else
        case pbMessage("\\ts[]" + _INTL("Este espacio está vacío."),
                       [_INTL("Depositar"), _INTL("Cancelar")], 2)
        when 0   # Deposit
          if $player.party.empty?
            pbMessage(_INTL("El equipo está vacío, no se pueden dejar Pokémon."))
          else
            pbChooseNonEggPokemon(1, 3)
            party_index = pbGet(1)
            if party_index >= 0
              pkmn = $player.party[party_index]
              slot.deposit(pkmn)
              $player.party.delete_at(party_index)
              day_care.reset_egg_counters
              need_refresh = true
            end
          end
        end
      end

    end
  end
  cmd_window.dispose
end

#===============================================================================
# Debug roaming Pokémon screen
#===============================================================================
class SpriteWindow_DebugRoamers < Window_DrawableCommand
  def initialize(viewport)
    super(0, 0, Graphics.width, Graphics.height, viewport)
  end

  def roamerCount
    return Settings::ROAMING_SPECIES.length
  end

  def itemCount
    return self.roamerCount + 2
  end

  def shadowtext(t, x, y, w, h, align = 0, colors = 0)
    y += 8   # TEXT OFFSET
    width = self.contents.text_size(t).width
    case align
    when 1
      x += (w - width)             # Right aligned
    when 2
      x += (w / 2) - (width / 2)   # Centre aligned
    end
    base = Color.new(96, 96, 96)
    case colors
    when 1
      base = Color.new(168, 48, 56)   # Red
    when 2
      base = Color.new(0, 144, 0)     # Green
    end
    pbDrawShadowText(self.contents, x, y, [width, w].max, h, t, base, Color.new(208, 208, 200))
  end

  def drawItem(index, _count, rect)
    pbSetNarrowFont(self.contents)
    rect = drawCursor(index, rect)
    nameWidth   = rect.width * 50 / 100
    statusWidth = rect.width * 50 / 100
    if index == self.itemCount - 2
      # Advance roaming
      self.shadowtext(_INTL("[Todos los errantes a nuevas localizaciones]"), rect.x, rect.y, nameWidth, rect.height)
    elsif index == self.itemCount - 1
      # Advance roaming
      self.shadowtext(_INTL("[Vaciar todas las localizaciones de errantes]"), rect.x, rect.y, nameWidth, rect.height)
    else
      pkmn = Settings::ROAMING_SPECIES[index]
      name = GameData::Species.get(pkmn[0]).name + " (Nv. #{pkmn[1]})"
      status = ""
      statuscolor = 0
      if pkmn[2] <= 0 || $game_switches[pkmn[2]]
        status = $PokemonGlobal.roamPokemon[index]
        if status == true
          if $PokemonGlobal.roamPokemonCaught[index]
            status = "[CAPTURADO]"
          else
            status = "[DERROTADO]"
          end
          statuscolor = 1
        else
          # roaming
          curmap = $PokemonGlobal.roamPosition[index]
          if curmap
            mapinfos = pbLoadMapInfos
            status = "[ROAMING][#{curmap}: #{mapinfos[curmap].name}]"
          else
            status = "[ROAMING][map not set]"
          end
          statuscolor = 2
        end
      else
        status = "[NOT ROAMING][Switch #{pkmn[2]} is off]"
      end
      self.shadowtext(name, rect.x, rect.y, nameWidth, rect.height)
      self.shadowtext(status, rect.x + nameWidth, rect.y, statusWidth, rect.height, 1, statuscolor)
    end
  end
end

#===============================================================================
#
#===============================================================================
def pbDebugRoamers
  viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
  viewport.z = 99999
  sprites = {}
  sprites["cmdwindow"] = SpriteWindow_DebugRoamers.new(viewport)
  cmdwindow = sprites["cmdwindow"]
  cmdwindow.active = true
  loop do
    Graphics.update
    Input.update
    pbUpdateSpriteHash(sprites)
    if cmdwindow.index < cmdwindow.roamerCount
      pkmn = Settings::ROAMING_SPECIES[cmdwindow.index]
    else
      pkmn = nil
    end
    if Input.trigger?(Input::ACTION) && cmdwindow.index < cmdwindow.roamerCount &&
       (pkmn[2] <= 0 || $game_switches[pkmn[2]]) &&
       $PokemonGlobal.roamPokemon[cmdwindow.index] != true
      # Roam selected Pokémon
      pbPlayDecisionSE
      if Input.press?(Input::CTRL)   # Roam to current map
        if $PokemonGlobal.roamPosition[cmdwindow.index] == pbDefaultMap
          $PokemonGlobal.roamPosition[cmdwindow.index] = nil
        else
          $PokemonGlobal.roamPosition[cmdwindow.index] = pbDefaultMap
        end
      else   # Roam to a random other map
        oldmap = $PokemonGlobal.roamPosition[cmdwindow.index]
        pbRoamPokemonOne(cmdwindow.index)
        if $PokemonGlobal.roamPosition[cmdwindow.index] == oldmap
          $PokemonGlobal.roamPosition[cmdwindow.index] = nil
          pbRoamPokemonOne(cmdwindow.index)
        end
        $PokemonGlobal.roamedAlready = false
      end
      cmdwindow.refresh
    elsif Input.trigger?(Input::BACK)
      pbPlayCancelSE
      break
    elsif Input.trigger?(Input::USE)
      if cmdwindow.index < cmdwindow.roamerCount
        pbPlayDecisionSE
        # Toggle through roaming, not roaming, defeated
        if pkmn[2] > 0 && !$game_switches[pkmn[2]]
          # not roaming -> roaming
          $game_switches[pkmn[2]] = true
        elsif $PokemonGlobal.roamPokemon[cmdwindow.index] != true
          # roaming -> defeated
          $PokemonGlobal.roamPokemon[cmdwindow.index] = true
          $PokemonGlobal.roamPokemonCaught[cmdwindow.index] = false
        elsif $PokemonGlobal.roamPokemon[cmdwindow.index] == true &&
              !$PokemonGlobal.roamPokemonCaught[cmdwindow.index]
          # defeated -> caught
          $PokemonGlobal.roamPokemonCaught[cmdwindow.index] = true
        elsif pkmn[2] > 0
          # caught -> not roaming (or roaming if Switch ID is 0)
          $game_switches[pkmn[2]] = false if pkmn[2] > 0
          $PokemonGlobal.roamPokemon[cmdwindow.index] = nil
          $PokemonGlobal.roamPokemonCaught[cmdwindow.index] = false
        end
        cmdwindow.refresh
      elsif cmdwindow.index == cmdwindow.itemCount - 2   # All roam
        if Settings::ROAMING_SPECIES.length == 0
          pbPlayBuzzerSE
        else
          pbPlayDecisionSE
          pbRoamPokemon
          $PokemonGlobal.roamedAlready = false
          cmdwindow.refresh
        end
      else   # Clear all roaming locations
        if Settings::ROAMING_SPECIES.length == 0
          pbPlayBuzzerSE
        else
          pbPlayDecisionSE
          Settings::ROAMING_SPECIES.length.times do |i|
            $PokemonGlobal.roamPosition[i] = nil
          end
          $PokemonGlobal.roamedAlready = false
          cmdwindow.refresh
        end
      end
    end
  end
  pbDisposeSpriteHash(sprites)
  viewport.dispose
end

#===============================================================================
# Battle animations import/export
#===============================================================================
def pbExportAllAnimations
  begin
    Dir.mkdir("Animations") rescue nil
    animations = pbLoadBattleAnimations
    if animations
      msgwindow = pbCreateMessageWindow
      animations.each do |anim|
        next if !anim || anim.length == 0 || anim.name == ""
        pbMessageDisplay(msgwindow, anim.name, false)
        Graphics.update
        safename = anim.name.gsub(/\W/, "_")
        Dir.mkdir("Animations/#{safename}") rescue nil
        File.open("Animations/#{safename}/#{safename}.anm", "wb") do |f|
          f.write(BattleAnimationEditor.dumpBase64Anim(anim))
        end
        if anim.graphic && anim.graphic != ""
          graphicname = RTP.getImagePath("Graphics/Animations/" + anim.graphic)
          pbSafeCopyFile(graphicname, "Animations/#{safename}/" + File.basename(graphicname))
        end
        anim.timing.each do |timing|
          if !timing.timingType || timing.timingType == 0
            if timing.name && timing.name != ""
              audioName = RTP.getAudioPath("Audio/SE/Anim/" + timing.name)
              pbSafeCopyFile(audioName, "Animations/#{safename}/" + File.basename(audioName))
            end
          elsif timing.timingType == 1 || timing.timingType == 3
            if timing.name && timing.name != ""
              graphicname = RTP.getImagePath("Graphics/Animations/" + timing.name)
              pbSafeCopyFile(graphicname, "Animations/#{safename}/" + File.basename(graphicname))
            end
          end
        end
      end
      pbDisposeMessageWindow(msgwindow)
      pbMessage(_INTL("Todas las animaciones se han extraído y guardado en la carpeta Animations."))
    else
      pbMessage(_INTL("No hay animaciones que exportar."))
    end
  rescue
    p $!.message, $!.backtrace
    pbMessage(_INTL("Ha fallado el exportado."))
  end
end

def pbImportAllAnimations
  animationFolders = []
  if FileTest.directory?("Animations")
    Dir.foreach("Animations") do |fb|
      f = "Animations/" + fb
      animationFolders.push(f) if FileTest.directory?(f) && fb != "." && fb != ".."
    end
  end
  if animationFolders.length == 0
    pbMessage(_INTL("No hay animaciones que importar. Pon cada animación en una carpeta dentro de la carpeta Animations."))
  else
    msgwindow = pbCreateMessageWindow
    animations = pbLoadBattleAnimations
    animations = PBAnimations.new if !animations
    animationFolders.each do |folder|
      pbMessageDisplay(msgwindow, folder, false)
      Graphics.update
      audios = []
      files = Dir.glob(folder + "/*.*")
      ["wav", "ogg", "mid", "wma"].each do |ext|   # mp3
        upext = ext.upcase
        audios.concat(files.find_all { |f| f[f.length - 3, 3] == ext })
        audios.concat(files.find_all { |f| f[f.length - 3, 3] == upext })
      end
      audios.each do |audio|
        pbSafeCopyFile(audio, RTP.getAudioPath("Audio/SE/Anim/" + File.basename(audio)), "Audio/SE/Anim/" + File.basename(audio))
      end
      images = []
      ["png", "gif"].each do |ext|   # jpg jpeg bmp
        upext = ext.upcase
        images.concat(files.find_all { |f| f[f.length - 3, 3] == ext })
        images.concat(files.find_all { |f| f[f.length - 3, 3] == upext })
      end
      images.each do |image|
        pbSafeCopyFile(image, RTP.getImagePath("Graphics/Animations/" + File.basename(image)), "Graphics/Animations/" + File.basename(image))
      end
      Dir.glob(folder + "/*.anm") do |f|
        textdata = BattleAnimationEditor.loadBase64Anim(IO.read(f)) rescue nil
        if textdata.is_a?(PBAnimation)
          index = pbAllocateAnimation(animations, textdata.name)
          missingFiles = []
          textdata.name = File.basename(folder) if textdata.name == ""
          textdata.id = -1   # This is not an RPG Maker XP animation
          BattleAnimationEditor.pbConvertAnimToNewFormat(textdata)
          if textdata.graphic && textdata.graphic != "" &&
             !FileTest.exist?(folder + "/" + textdata.graphic) &&
             !FileTest.image_exist?("Graphics/Animations/" + textdata.graphic)
            textdata.graphic = ""
            missingFiles.push(textdata.graphic)
          end
          textdata.timing.each do |timing|
            next if !timing.name || timing.name == "" ||
                    FileTest.exist?(folder + "/" + timing.name) ||
                    FileTest.audio_exist?("Audio/SE/Anim/" + timing.name)
            timing.name = ""
            missingFiles.push(timing.name)
          end
          animations[index] = textdata
        end
      end
    end
    save_data(animations, "Data/PkmnAnimations.rxdata")
    $game_temp.battle_animations_data = nil
    pbDisposeMessageWindow(msgwindow)
    pbMessage(_INTL("Todas las animaciones se han importado."))
  end
end

#===============================================================================
# Properly erases all non-existent tiles in maps (including event graphics)
#===============================================================================
def pbDebugFixInvalidTiles
  total_errors = 0
  num_error_maps = 0
  tilesets = $data_tilesets
  mapData = Compiler::MapData.new
  t = System.uptime
  Graphics.update
  total_maps = mapData.mapinfos.keys.length
  Console.echo_h1(_INTL("Comprobando {1} mapas para tiles inválidos", total_maps))
  mapData.mapinfos.keys.sort.each do |id|
    if System.uptime - t >= 5
      t += 5
      Graphics.update
    end
    map_errors = 0
    map = mapData.getMap(id)
    next if !map || !mapData.mapinfos[id]
    passages = mapData.getTilesetPassages(map, id)
    # Check all tiles in map for non-existent tiles
    map.data.xsize.times do |x|
      map.data.ysize.times do |y|
        map.data.zsize.times do |i|
          tile_id = map.data[x, y, i]
          next if pbCheckTileValidity(tile_id, map, tilesets, passages)
          map.data[x, y, i] = 0
          map_errors += 1
        end
      end
    end
    # Check all events in map for page graphics using a non-existent tile
    map.events.each_key do |key|
      event = map.events[key]
      event.pages.each do |page|
        next if page.graphic.tile_id <= 0
        next if pbCheckTileValidity(page.graphic.tile_id, map, tilesets, passages)
        page.graphic.tile_id = 0
        map_errors += 1
      end
    end
    next if map_errors == 0
    # Map was changed; save it
    Console.echoln_li(_INTL("{1} errores de tile(s) encontrados en el mapa {2}: {3}.", map_errors, id, mapData.mapinfos[id].name))
    total_errors += map_errors
    num_error_maps += 1
    mapData.saveMap(id)
  end
  if num_error_maps == 0
    Console.echo_h2(_INTL("Listo. No se han encontrado errores."), text: :green)
    pbMessage(_INTL("No se han encontrado tiles inválidos."))
  else
    echoln ""
    Console.echo_h2(_INTL("Listo. {1} errores encontrados y arreglados.", total_errors), text: :green)
    Console.echo_warn(_INTL("Los datos de RMXP se han alterado. Cierra RMXP ahora para asegurarte de que los cambios se han aplicados."))
    echoln ""
    pbMessage(_INTL("{1} errores se han encontrado en {2} mapas y se han arreglado.", total_errors, num_error_maps))
    pbMessage(_INTL("Cierra RPG Maker XP para asegurarte de que los cambios se han aplicado correctamente."))
  end
end

def pbCheckTileValidity(tile_id, map, tilesets, passages)
  return false if !tile_id
  if tile_id > 0 && tile_id < 384
    # Check for defined autotile
    autotile_id = (tile_id / 48) - 1
    autotile_name = tilesets[map.tileset_id].autotile_names[autotile_id]
    return true if autotile_name && autotile_name != ""
  else
    # Check for tileset data
    return true if passages[tile_id]
  end
  return false
end

#===============================================================================
# Pseudo-party screen for editing Pokémon being set up for a wild battle
#===============================================================================
class PokemonDebugPartyScreen
  def initialize
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @messageBox = Window_AdvancedTextPokemon.new("")
    @messageBox.viewport       = @viewport
    @messageBox.visible        = false
    @messageBox.letterbyletter = true
    pbBottomLeftLines(@messageBox, 2)
    @helpWindow = Window_UnformattedTextPokemon.new("")
    @helpWindow.viewport = @viewport
    @helpWindow.visible  = true
    pbBottomLeftLines(@helpWindow, 1)
  end

  def pbEndScreen
    @messageBox.dispose
    @helpWindow.dispose
    @viewport.dispose
  end

  def pbDisplay(text)
    @messageBox.text    = text
    @messageBox.visible = true
    @helpWindow.visible = false
    pbPlayDecisionSE
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if @messageBox.busy?
        if Input.trigger?(Input::USE)
          pbPlayDecisionSE if @messageBox.pausing?
          @messageBox.resume
        end
      else
        if Input.trigger?(Input::BACK) || Input.trigger?(Input::USE)
          break
        end
      end
    end
    @messageBox.visible = false
    @helpWindow.visible = true
  end

  def pbConfirm(text)
    ret = -1
    @messageBox.text    = text
    @messageBox.visible = true
    @helpWindow.visible = false
    using(cmdwindow = Window_CommandPokemon.new([_INTL("Yes"), _INTL("No")])) do
      cmdwindow.visible = false
      pbBottomRight(cmdwindow)
      cmdwindow.y -= @messageBox.height
      cmdwindow.z = @viewport.z + 1
      loop do
        Graphics.update
        Input.update
        cmdwindow.visible = true if !@messageBox.busy?
        cmdwindow.update
        pbUpdate
        if !@messageBox.busy?
          if Input.trigger?(Input::BACK)
            ret = false
            break
          elsif Input.trigger?(Input::USE) && @messageBox.resume
            ret = (cmdwindow.index == 0)
            break
          end
        end
      end
    end
    @messageBox.visible = false
    @helpWindow.visible = true
    return ret
  end

  def pbShowCommands(text, commands, index = 0)
    ret = -1
    @helpWindow.visible = true
    using(cmdwindow = Window_CommandPokemonColor.new(commands)) do
      cmdwindow.z     = @viewport.z + 1
      cmdwindow.index = index
      pbBottomRight(cmdwindow)
      @helpWindow.resizeHeightToFit(text, Graphics.width - cmdwindow.width)
      @helpWindow.text = text
      pbBottomLeft(@helpWindow)
      loop do
        Graphics.update
        Input.update
        cmdwindow.update
        pbUpdate
        if Input.trigger?(Input::BACK)
          pbPlayCancelSE
          ret = -1
          break
        elsif Input.trigger?(Input::USE)
          pbPlayDecisionSE
          ret = cmdwindow.index
          break
        end
      end
    end
    return ret
  end

  def pbChooseMove(pkmn, text, index = 0)
    moveNames = []
    pkmn.moves.each do |i|
      if i.total_pp <= 0
        moveNames.push(_INTL("{1} (PP: ---)", i.name))
      else
        moveNames.push(_INTL("{1} (PP: {2}/{3})", i.name, i.pp, i.total_pp))
      end
    end
    return pbShowCommands(text, moveNames, index)
  end

  def pbRefreshSingle(index); end

  def update
    @messageBox.update
    @helpWindow.update
  end
  alias pbUpdate update
end
