MenuHandlers.add(:debug_menu,:exportmaps, {
  "parent"      => :field_menu,
  "name"        => _INTL("Exportar mapas"),
  "description" => _INTL("Elige un mapa para exportarlo como PNG."),
})

MenuHandlers.add(:debug_menu,:exportOneMap, {
  "parent"      => :exportmaps,
  "name"        => _INTL("Exportar un solo mapa"),
  "description" => _INTL("Elige un mapa para exportarlo como PNG."),
  "effect"      => proc {
    mapid = pbListScreen(_INTL("Export Map"),MapLister.new(pbDefaultMap))
    if mapid > 0
      options = pbExportOption
      if options
        pbExportMap(mapid, options)
        echoln "#{sprintf("Map%03d.rxdata",mapid)} Exported!"
      end
    end  
  }
})

MenuHandlers.add(:debug_menu,:exportAllMaps, {
  "parent"      => :exportmaps,
  "name"        => _INTL("Exportar todos los mapas"),
  "description" => _INTL("Te permite exportar todos los mapas."),
  "effect"      => proc {
    options = pbExportOption
    if options
      mapinfos = pbLoadMapInfos
      totalMaps = mapinfos.keys.length
      index = 1
      mapnames=[]
      for map_id in mapinfos.keys
        map_name = "map_#{map_id}"
        pbExportMap(map_id, options, map_name)
        echoln "#{map_name} Exported! (#{index}/#{totalMaps})"
        index += 1
      end  
    end  
  }
})

#================================================
def pbExportOption
  options = []
  cmds = ["Export"]
  cmds.push("[X] Map Graphics")
  cmds.push("[  ] Events")
  cmds.push("[  ] Player")
  cmds.push("[  ] Colissions")
  cmds.push("[  ] Terrain Tags Colissions")
  cmds.push("[  ] Events Colissions")
  cmds.push("[  ] Special Collisions")
  cmds.push("Cancel")
  cmd = 0
  loop do
    cmd = Kernel.pbShowCommands(nil,cmds,-1,cmd)
    if cmd == 0
      options << :map_graph       if cmds[1].split("")[1] == "X"
      options << :events          if cmds[2].split("")[1] == "X"
      options << :player          if cmds[3].split("")[1] == "X"
      options << :colissions      if cmds[4].split("")[1] == "X"
      options << :coll_terrain_tag  if cmds[5].split("")[1] == "X"
      options << :coll_events     if cmds[6].split("")[1] == "X"
      options << :special_coll    if cmds[7].split("")[1] == "X"
      break
    elsif cmd == 1
      if cmds[1].split("")[1] == " "
          cmds[1] = "[X] Map Graphics"
      else
          cmds[1] = "[  ] Map Graphics"
      end
    elsif cmd == 2
      if cmds[2].split("")[1] == " "
        cmds[2] = "[X] Events"
      else
        cmds[2] = "[  ] Events"
      end
    elsif cmd == 3 
      if cmds[3].split("")[1] == " "
        cmds[3] = "[X] Player"
      else
        cmds[3] = "[  ] Player"
      end
    elsif cmd == 4 
      if cmds[4].split("")[1] == " "
        cmds[4] = "[X] Colissions"
      else
        cmds[4] = "[  ] Colissions"
      end
    elsif cmd == 5 
      if cmds[5].split("")[1] == " "
        cmds[5] = "[X] Terrain Tags Colissions"
      else
        cmds[5] = "[  ] Terrain Tags Colissions"
      end
    elsif cmd == 6 
      if cmds[6].split("")[1] == " "
        cmds[6] = "[X] Events Colissions"
      else
        cmds[6] = "[  ] Events Colissions"
      end
    elsif cmd == 7 
      if cmds[7].split("")[1] == " "
        cmds[7] = "[X] Special Collisions"
      else
        cmds[7] = "[  ] Special Collisions"
        cmds[6] = "[  ] Events Colissions"
        cmds[5] = "[  ] Terrain Tags Colissions"
        cmds[4] = "[  ] Colissions"
      end
    elsif cmd == (cmds.length - 1) || cmd == -1
      options = nil
      break
    end
  end
  return options
end