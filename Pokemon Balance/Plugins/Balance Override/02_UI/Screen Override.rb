class Game_Player < Game_Character
    attr_accessor :charsetData
    attr_accessor :encounter_count
  
    SCREEN_CENTER_X = (Settings::SCREEN_WIDTH / 2.2) * Game_Map::X_SUBPIXELS
    SCREEN_CENTER_Y = (Settings::SCREEN_HEIGHT / 2.3) * Game_Map::Y_SUBPIXELS
    # Time in seconds for one cycle of bobbing (playing 4 charset frames) while
    # surfing or diving.
    SURF_BOB_DURATION = 1.5

end