module MapExporterGenerator
    # Method which checks whether a tile has a terrain tag.
    def self.drawTerrainTag(map, passa_bitmap)
        tileset = $data_tilesets[map.tileset_id]
        terrainTags = tileset.terrain_tags
        passa_terrain = []

        for i in 0...map.width
            for j in 0...map.height
                for z in [2,1,0]
                    tileID = map.data[i,j,z]
                    tileID = GameData::TerrainTag.try_get(terrainTags[tileID]).id_number
                    if tileID && tileID > 0
                        passa_terrain.push([
                            _INTL("{1}",tileID),
                            16+32*i,
                            2+32*j,
                            :center,
                            PASSA_TERRAIN_COLOR,
                            PASSA_TERRAIN_COLOR2
                        ])
                    end
                end
            end
        end
        pbDrawTextPositions(passa_bitmap,passa_terrain)
    end
end