def pbExportMap(map_id = nil, options = [],file_name="exported map")
  map_id = $game_map.map_id if !map_id
  data = load_data(sprintf("Data/Map%03d.rxdata",map_id)) rescue nil
  return if !data
  mapBitmapResult = Bitmap.new(32 * data.width, 32 * data.height)
  tilesetdata = load_data("Data/Tilesets.rxdata")
  tileset = tilesetdata[data.tileset_id]
  
  if options.include?(:map_graph)
    helper=TileDrawingHelper.fromTileset(tileset)
    for y in 0...data.height
      for x in 0...data.width
        for z in 0..2
          id=data.data[x,y,z]
          id=0 if !id
          helper.bltTile(mapBitmapResult,x*32,y*32,id)
        end
      end
    end
  end

  if options.include?(:events)
    keys = data.events.keys.sort { |a, b| data.events[a].y <=> data.events[b].y }
    keys.each do |id|
      event = data.events[id]
      page = pbGetActiveEventPage(event, id)
      if page && page.graphic && page.graphic.character_name
        next if !pbResolveBitmap("Graphics/Characters/#{page.graphic.character_name}")
        bmp = Bitmap.new("Graphics/Characters/#{page.graphic.character_name}")
        if bmp
          bmp = bmp.clone
          bmp.hue_change(page.graphic.character_hue) unless page.graphic.character_hue == 0
          ex = bmp.width / 4 * page.graphic.pattern
          ey = bmp.height / 4 * (page.graphic.direction / 2 - 1)
          mapBitmapResult.blt(event.x * 32 + 16 - bmp.width / 8, (event.y + 1) * 32 - bmp.height / 4, bmp,
              Rect.new(ex, ey, bmp.width / 4, bmp.height / 4))
        end
        bmp = nil
      end
    end
  end

  if options.include?(:player) && $game_map.map_id == map_id
    bmp = Bitmap.new("Graphics/Characters/#{$game_player.character_name}")
    dir = $game_player.direction
    mapBitmapResult.blt($game_player.x * 32 + 16 - bmp.width / 8, ($game_player.y + 1) * 32 - bmp.height / 4,
        bmp, Rect.new(0, bmp.height / 4 * (dir / 2 - 1), bmp.width / 4, bmp.height / 4))
  end
  
  if options.include?(:colissions)
    MapExporterGenerator::getPassabilityMap(
      data, 
      mapBitmapResult
    )
  end
    
  if options.include?(:coll_terrain_tag)
    MapExporterGenerator::drawTerrainTag(
      data, 
      mapBitmapResult,
    )
  end

  if options.include?(:coll_events)
    passBitmap = MapExporterGenerator::drawEvents(
      data, 
      mapBitmapResult
    )
  end

  if options.include?(:special_coll)
    passBitmap = MapExporterGenerator::getSpecialPassabilityMap(
      data, 
      mapBitmapResult
    )
  end

  ubication = "Exported Maps/#{file_name}.png"
  mapBitmapResult.to_file(ubication)
  Input.update
end

