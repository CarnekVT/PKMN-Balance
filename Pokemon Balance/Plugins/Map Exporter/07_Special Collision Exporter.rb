module MapExporterGenerator
    def self.getSpecialPassabilityMap(map, bitmap)
        tileset = $data_tilesets[map.tileset_id]
        terrainTags = tileset.terrain_tags
    
        minimap = AnimatedBitmap.new("Graphics/Plugins/MapExporter/NoPass")
        passtable = Table.new(map.width,map.height)
    
        grassMap = AnimatedBitmap.new("Graphics/Plugins/MapExporter/Grass")
        grasstable = Table.new(map.width,map.height)

        passages = tileset.passages
    
        for i in 0...map.width
            for j in 0...map.height
                pass=true
                grasstable[i,j]=1
                for z in [2,1,0]
                    tileID = map.data[i,j,z]
                    tileType = GameData::TerrainTag.try_get(terrainTags[tileID]).id
                    
                    if tileType == :Grass
                        grasstable[i,j]=0
                        pass=true
                        break
                    end
            
                    if !passable?(passages,map.data[i,j,z])
                        pass=false
                        break
                    end
                end
                passtable[i,j]=pass ? 1 : 0
            end
        end
    
        neighbors=TileDrawingHelper::NEIGHBORS_TO_AUTOTILE_INDEX
        for i in 0...map.width
            for j in 0...map.height
                if passtable[i,j]==0
                nb=TileDrawingHelper.tableNeighbors(passtable,i,j)
                tile=neighbors[nb]
                bltMinimapAutotile(bitmap,i*32,j*32,minimap.bitmap,tile)
                end
                if grasstable[i,j]==0
                nb=TileDrawingHelper.tableNeighbors(grasstable,i,j)
                tile=neighbors[nb]
                bltMinimapAutotile(bitmap,i*32,j*32,grassMap.bitmap,tile)
                end
            end
        end
        minimap.dispose
    end

    # From Marin
    def self.pbGetActiveEventPage(event, mapid = nil)
        mapid ||= event.map.map_id if event.respond_to?(:map)
        pages = (event.is_a?(RPG::Event) ? event.pages : event.instance_eval { event.pages })
        for i in 0...pages.size
            c = pages[pages.size - 1 - i].condition
            ss = !(c.self_switch_valid && !$game_self_switches[[mapid,
                event.id,c.self_switch_ch]])
            sw1 = !(c.switch1_valid && !$game_switches[c.switch1_id])
            sw2 = !(c.switch2_valid && !$game_switches[c.switch2_id])
            var = true
            if c.variable_valid
            if !c.variable_value || !$game_variables[c.variable_id].is_a?(Numeric) ||
                $game_variables[c.variable_id] < c.variable_value
                var = false
            end
            end
            if ss && sw1 && sw2 && var # All conditions are met
            return pages[pages.size - 1 - i]
            end
        end
        return nil
    end
    
    def self.bltMinimapAutotile(dstBitmap,x,y,srcBitmap,id)
        return if id>=48 || !srcBitmap || srcBitmap.disposed?
        cxTile=16
        cyTile=16
        tiles = TileDrawingHelper::AUTOTILE_PATTERNS[id>>3][id&7]
        src=Rect.new(0,0,0,0)
        for i in 0...4
        tile_position = tiles[i] - 1
        src.set(
            tile_position % 6 * cxTile,
            tile_position / 6 * cyTile, 
            cxTile, 
            cyTile
        )
        dstBitmap.blt(
            i%2*cxTile+x,
            i/2*cyTile+y, 
            srcBitmap, 
            src
        )
        end
    end
end