module MapExporterGenerator
    def self.getPassabilityMap(map, passa_bitmap)
        # passa_bitmap=Bitmap.new(map.width*32,map.height*32)
        passa_terrain=[]
        # Filling the fields.
        for xval in 0..map.width
            for yval in 0..map.height
                x=xval*32
                y=yval*32
                drawPlayerPassable(passa_bitmap, x, y, xval, yval, map)
            end
        end
        return passa_bitmap
    end

    def self.drawPlayerPassable(passa_bitmap, x, y, xval, yval, map)
        if !playerPassable?(xval, yval, 2, map) # DOWN
            passa_bitmap.fill_rect(
                x,
                y+32-PASSA_FIELD_SIZE,
                32,
                PASSA_FIELD_SIZE,
                PASSA_FIELD_COLOR
            )
        end
        if !playerPassable?(xval, yval, 4, map) # LEFT
            passa_bitmap.fill_rect(
                x,
                y,
                PASSA_FIELD_SIZE,
                32,
                PASSA_FIELD_COLOR
            )
        end
        if !playerPassable?(xval, yval, 6, map) # RIGHT
            passa_bitmap.fill_rect(
                x+32-PASSA_FIELD_SIZE,
                y,
                PASSA_FIELD_SIZE,
                32,
                PASSA_FIELD_COLOR
            )
        end
        if !playerPassable?(xval, yval, 8, map) # UP
            passa_bitmap.fill_rect(
                x,
                y,
                32,
                PASSA_FIELD_SIZE,
                PASSA_FIELD_COLOR
            )
        end
    end
    
    # Exception `ArgumentError' at 004_Validation.rb:29 - Argumento no válido pasado al método.
    # Se esperaba que [413] fuera uno de [Symbol, GameData::TerrainTag, String, Integer], pero se obtuvo Array.
    def self.playerPassable?(x, y, d, map)
        bit = (1 << ((d / 2) - 1)) & 0x0f
        tileset = $data_tilesets[map.tileset_id]
        passa_priorities    = tileset.priorities
        passa_terrain_tags  = tileset.terrain_tags
        passa_passages      = tileset.passages
        passa_data          = map.data
        #-------------------------------------
        [2, 1, 0].each do |i|
        tile_id = passa_data[x, y, i]
        next if tile_id == 0 || tile_id == nil
        terrain = GameData::TerrainTag.try_get(passa_terrain_tags[tile_id])
        passage = passa_passages[tile_id]
        if terrain
            # Ignore bridge tiles if not on a bridge
            next if terrain.bridge
            # Make water tiles passable if player is surfing
            return true if terrain.can_surf && !terrain.waterfall
            # Prevent cycling in really tall grass/on ice
            return false if (terrain.must_walk || terrain.must_walk_or_run)
            # Depend on passability of bridge tile if on bridge
            if terrain.bridge && $PokemonGlobal.bridge > 0
            return (passage & bit == 0 && passage & 0x0f != 0x0f)
            end
        end
        next if terrain&.ignore_passability
        # Regular passability checks
        return false if passage & bit != 0 || passage & 0x0f == 0x0f
        return true if !passa_priorities[tile_id] || passa_priorities[tile_id] == 0
        end
        return true
    end
end