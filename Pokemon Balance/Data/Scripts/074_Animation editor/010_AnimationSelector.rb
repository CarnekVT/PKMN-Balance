#===============================================================================
#
#===============================================================================
class AnimationEditor::AnimationSelector
  BORDER_THICKNESS          = 4
  LABEL_OFFSET_X            = -4   # Position of label relative to what they're labelling
  LABEL_OFFSET_Y            = -32

  QUIT_BUTTON_WIDTH         = 80
  QUIT_BUTTON_HEIGHT        = 30

  TYPE_BUTTONS_X            = 2
  TYPE_BUTTONS_Y            = 62
  TYPE_BUTTON_WIDTH         = 100
  TYPE_BUTTON_HEIGHT        = 48

  LIST_BORDER_PADDING       = (UIControls::List::BORDER_THICKNESS * 2)
  MOVES_LIST_X              = TYPE_BUTTONS_X + TYPE_BUTTON_WIDTH + 2
  MOVES_LIST_Y              = TYPE_BUTTONS_Y + 2
  MOVES_LIST_WIDTH          = 200 + LIST_BORDER_PADDING
  MOVES_LIST_HEIGHT         = AnimationEditor::WINDOW_HEIGHT - MOVES_LIST_Y - LIST_BORDER_PADDING
  MOVES_LIST_HEIGHT         = (((MOVES_LIST_HEIGHT - LIST_BORDER_PADDING) / UIControls::List::ROW_HEIGHT) * UIControls::List::ROW_HEIGHT)
  MOVES_LIST_HEIGHT         += LIST_BORDER_PADDING

  ANIMATIONS_LIST_X         = MOVES_LIST_X + MOVES_LIST_WIDTH + 4
  ANIMATIONS_LIST_Y         = MOVES_LIST_Y
  ANIMATIONS_LIST_WIDTH     = 300 + LIST_BORDER_PADDING
  ANIMATIONS_LIST_HEIGHT    = MOVES_LIST_HEIGHT

  ACTION_BUTTON_WIDTH       = 200
  ACTION_BUTTON_HEIGHT      = 48
  ACTION_BUTTON_X           = ANIMATIONS_LIST_X + ANIMATIONS_LIST_WIDTH + 2
  ACTION_BUTTON_Y           = TYPE_BUTTONS_Y + ((ANIMATIONS_LIST_HEIGHT - (ACTION_BUTTON_HEIGHT * 3)) / 2) + 4

  FILTER_BOX_WIDTH          = ACTION_BUTTON_WIDTH
  FILTER_BOX_HEIGHT         = UIControls::TextBox::TEXT_BOX_HEIGHT
  FILTER_BOX_X              = ACTION_BUTTON_X
  FILTER_BOX_Y              = MOVES_LIST_Y

  # Pop-up window
  MESSAGE_BOX_WIDTH         = AnimationEditor::WINDOW_WIDTH * 3 / 4
  MESSAGE_BOX_HEIGHT        = 160
  MESSAGE_BOX_BUTTON_WIDTH  = 150
  MESSAGE_BOX_BUTTON_HEIGHT = 32
  MESSAGE_BOX_SPACING       = 16

  include AnimationEditor::SettingsMixin
  include UIControls::StyleMixin

  def initialize
    load_settings
    @animation_type = 0   # 0=move, 1=common
    @filter_text = ""
    @quit = false
    generate_full_lists
    initialize_viewports
    initialize_bitmaps
    initialize_controls
    self.color_scheme = @settings[:color_scheme]
    refresh
  end

  def initialize_viewports
    @viewport = Viewport.new(0, 0, AnimationEditor::WINDOW_WIDTH, AnimationEditor::WINDOW_HEIGHT)
    @viewport.z = 99999
    @pop_up_viewport = Viewport.new(0, 0, AnimationEditor::WINDOW_WIDTH, AnimationEditor::WINDOW_HEIGHT)
    @pop_up_viewport.z = @viewport.z + 50
  end

  def initialize_bitmaps
    # Background
    @screen_bitmap = BitmapSprite.new(AnimationEditor::WINDOW_WIDTH, AnimationEditor::WINDOW_HEIGHT, @viewport)
    # Semi-transparent black overlay to dim the screen while a pop-up window is open
    @pop_up_bg_bitmap = BitmapSprite.new(AnimationEditor::WINDOW_WIDTH, AnimationEditor::WINDOW_HEIGHT, @pop_up_viewport)
    @pop_up_bg_bitmap.z = -100
    @pop_up_bg_bitmap.visible = false
    # Draw in these bitmaps
    draw_editor_background
  end

  def initialize_controls
    @components = UIControls::ControlsContainer.new(0, 0, AnimationEditor::WINDOW_WIDTH, AnimationEditor::WINDOW_HEIGHT)
    # Quit button
    btn = UIControls::Button.new(QUIT_BUTTON_WIDTH, QUIT_BUTTON_HEIGHT, @viewport, _INTL("Salir"))
    btn.set_fixed_size
    @components.add_control_at(:quit, btn, 0, 0)
    # New button
    btn = UIControls::Button.new(QUIT_BUTTON_WIDTH, QUIT_BUTTON_HEIGHT, @viewport, _INTL("Nuevo"))
    btn.set_fixed_size
    @components.add_control_at(:new, btn, QUIT_BUTTON_WIDTH, 0)
    # Type label
    label = UIControls::Label.new(TYPE_BUTTON_WIDTH, TYPE_BUTTON_HEIGHT, @viewport, _INTL("Tipos de anim"))
    label.header = true
    @components.add_control_at(:type_label, label, TYPE_BUTTONS_X + LABEL_OFFSET_X + 4, TYPE_BUTTONS_Y + LABEL_OFFSET_Y + 4)
    # Animation type toggle buttons
    [[:moves, _INTL("Movimientos")], [:commons, _INTL("Commons")]].each_with_index do |val, i|
      btn = UIControls::Button.new(TYPE_BUTTON_WIDTH, TYPE_BUTTON_HEIGHT, @viewport, val[1])
      btn.set_fixed_size
      @components.add_control_at(val[0], btn, TYPE_BUTTONS_X, TYPE_BUTTONS_Y + (i * TYPE_BUTTON_HEIGHT))
    end
    # Moves list label
    label = UIControls::Label.new(MOVES_LIST_WIDTH, TYPE_BUTTON_HEIGHT, @viewport, _INTL("Movimientos"))
    label.header = true
    @components.add_control_at(:moves_label, label, MOVES_LIST_X + LABEL_OFFSET_X, MOVES_LIST_Y + LABEL_OFFSET_Y)
    # Moves list
    list = UIControls::List.new(MOVES_LIST_WIDTH, MOVES_LIST_HEIGHT, @viewport, [])
    @components.add_control_at(:moves_list, list, MOVES_LIST_X, MOVES_LIST_Y)
    # Animations list label
    label = UIControls::Label.new(ANIMATIONS_LIST_WIDTH, TYPE_BUTTON_HEIGHT, @viewport, _INTL("Animaciones"))
    label.header = true
    @components.add_control_at(:animations_label, label, ANIMATIONS_LIST_X + LABEL_OFFSET_X, ANIMATIONS_LIST_Y + LABEL_OFFSET_Y)
    # Animations list
    list = UIControls::List.new(ANIMATIONS_LIST_WIDTH, ANIMATIONS_LIST_HEIGHT, @viewport, [])
    @components.add_control_at(:animations_list, list, ANIMATIONS_LIST_X, ANIMATIONS_LIST_Y)
    # Edit, Copy and Delete buttons
    [[:edit, _INTL("Editar animación")], [:copy, _INTL("Copiar animación")], [:delete, _INTL("Eliminar animación")]].each_with_index do |val, i|
      btn = UIControls::Button.new(ACTION_BUTTON_WIDTH, ACTION_BUTTON_HEIGHT, @viewport, val[1])
      btn.set_fixed_size
      @components.add_control_at(val[0], btn, ACTION_BUTTON_X, ACTION_BUTTON_Y + (i * ACTION_BUTTON_HEIGHT))
    end
    # Filter text box
    text_box = UIControls::TextBox.new(FILTER_BOX_WIDTH, FILTER_BOX_HEIGHT, @viewport, "")
    @components.add_control_at(:filter, text_box, FILTER_BOX_X, FILTER_BOX_Y)
    # Filter text box label
    label = UIControls::Label.new(FILTER_BOX_WIDTH, TYPE_BUTTON_HEIGHT, @viewport, _INTL("Texto de filtro"))
    label.header = true
    @components.add_control_at(:filter_label, label, FILTER_BOX_X + LABEL_OFFSET_X, FILTER_BOX_Y + LABEL_OFFSET_Y)
  end

  def dispose
    @screen_bitmap.dispose
    @pop_up_bg_bitmap.dispose
    @components.dispose
    @viewport.dispose
    @pop_up_viewport.dispose
  end

  #-----------------------------------------------------------------------------

  def color_scheme=(value)
    return if @color_scheme == value
    @color_scheme = value
    draw_editor_background
    @components.color_scheme = value
    refresh
  end

  #-----------------------------------------------------------------------------

  def draw_editor_background
    # Fill the whole screen with white
    @screen_bitmap.bitmap.fill_rect(0, 0, AnimationEditor::WINDOW_WIDTH, AnimationEditor::WINDOW_HEIGHT, background_color)
    # Make the pop-up background semi-transparent
    @pop_up_bg_bitmap.bitmap.fill_rect(0, 0, AnimationEditor::WINDOW_WIDTH, AnimationEditor::WINDOW_HEIGHT, semi_transparent_color)
  end

  #-----------------------------------------------------------------------------

  def create_pop_up_window(width, height)
    ret = BitmapSprite.new(width + (BORDER_THICKNESS * 2),
                           height + (BORDER_THICKNESS * 2), @pop_up_viewport)
    ret.x = (AnimationEditor::WINDOW_WIDTH - ret.width) / 2
    ret.y = (AnimationEditor::WINDOW_HEIGHT - ret.height) / 2
    ret.z = -1
    ret.bitmap.font.color = text_color
    ret.bitmap.font.size = text_size
    # Draw pop-up box border
    ret.bitmap.border_rect(BORDER_THICKNESS, BORDER_THICKNESS, width, height,
                           BORDER_THICKNESS, background_color, line_color)
    # Fill pop-up box with white
    ret.bitmap.fill_rect(BORDER_THICKNESS, BORDER_THICKNESS, width, height, background_color)
    return ret
  end

  #-----------------------------------------------------------------------------

  def message(text, *options)
    @pop_up_bg_bitmap.visible = true
    msg_bitmap = create_pop_up_window(MESSAGE_BOX_WIDTH, MESSAGE_BOX_HEIGHT)
    # Draw text
    text_size = msg_bitmap.bitmap.text_size(text)
    msg_bitmap.bitmap.draw_text(0, (msg_bitmap.height / 2) - MESSAGE_BOX_BUTTON_HEIGHT,
                                msg_bitmap.width, text_size.height, text, 1)
    # Create buttons
    buttons = []
    options.each_with_index do |option, i|
      btn = UIControls::Button.new(MESSAGE_BOX_BUTTON_WIDTH, MESSAGE_BOX_BUTTON_HEIGHT, @pop_up_viewport, option[1])
      btn.x = msg_bitmap.x + (msg_bitmap.width - (MESSAGE_BOX_BUTTON_WIDTH * options.length)) / 2
      btn.x += MESSAGE_BOX_BUTTON_WIDTH * i
      btn.y = msg_bitmap.y + msg_bitmap.height - MESSAGE_BOX_BUTTON_HEIGHT - MESSAGE_BOX_SPACING
      btn.set_fixed_size
      btn.color_scheme = @color_scheme
      btn.set_interactive_rects
      buttons.push([option[0], btn])
    end
    # Interaction loop
    ret = nil
    captured = nil
    loop do
      Graphics.update
      Input.update
      if captured
        captured.update
        captured = nil if !captured.busy?
      else
        buttons.each do |btn|
          btn[1].update
          captured = btn[1] if btn[1].busy?
        end
      end
      buttons.each do |btn|
        next if !btn[1].changed?
        ret = btn[0]
        break
      end
      ret = :cancel if Input.triggerex?(:ESCAPE)
      break if ret
      buttons.each { |btn| btn[1].repaint }
    end
    # Dispose and return
    buttons.each { |btn| btn[1].dispose }
    buttons.clear
    msg_bitmap.dispose
    @pop_up_bg_bitmap.visible = false
    return ret
  end

  def confirm_message(text)
    return message(text, [:yes, _INTL("Sí")], [:no, _INTL("No")]) == :yes
  end

  #-----------------------------------------------------------------------------

  def generate_full_lists
    @full_move_animations = {}
    @full_common_animations = {}
    GameData::Animation.keys.each do |id|
      anim = GameData::Animation.get(id)
      name = ""
      name += "\\c[2]" if anim.ignore
      name += _INTL("[Enemigo]") + " " if anim.opposing_animation?
      name += "[#{anim.version}]" + " " if anim.version > 0
      name += (anim.name || anim.move)
      if anim.move_animation?
        move_name = GameData::Move.try_get(anim.move)&.name || anim.move
        move_key = anim.move.to_sym
        @full_move_animations[move_key] ||= []
        @full_move_animations[move_key].push([id, name, move_name])
      elsif anim.common_animation?
        common_key = anim.move.to_sym
        @full_common_animations[common_key] ||= []
        @full_common_animations[common_key].push([id, name])
      end
    end
    @full_move_animations.values.each do |val|
      val.sort! { |a, b| a[1] <=> b[1] }
    end
    @full_common_animations.values.each do |val|
      val.sort! { |a, b| a[1] <=> b[1] }
    end
    apply_list_filter
  end

  def apply_list_filter
    # Apply filter
    if @filter_text == ""
      @move_animations = @full_move_animations.clone
      @common_animations = @full_common_animations.clone
    else
      filter = @filter_text.downcase
      @move_animations.clear
      @full_move_animations.each_pair do |move, anims|
        anims.each do |anim|
          next if !anim[1].downcase.include?(filter) && !anim[2].downcase.include?(filter)
          @move_animations[move] ||= []
          @move_animations[move].push(anim)
        end
      end
      @common_animations.clear
      @full_common_animations.each_pair do |common, anims|
        anims.each do |anim|
          next if !anim[1].downcase.include?(filter) && !common.to_s.downcase.include?(filter)
          @common_animations[common] ||= []
          @common_animations[common].push(anim)
        end
      end
    end
    # Create move list from the filtered results
    @move_list = []
    @move_animations.each_pair do |move_id, anims|
      @move_list.push([move_id, anims[0][2]])
    end
    # Add moves without animations
    GameData::Move.keys.each do |move_id|
      next if @move_animations[move_id]
      move_data = GameData::Move.get(move_id)
      @move_list.push([move_id, move_data.name])
    end
    @move_list.uniq!
    @move_list.sort! { |a, b| a[1] <=> b[1] }
    @move_list.uniq!
    # Create common list from the filtered results
    @common_list = []
    @common_animations.each_pair do |move_id, anims|
      @common_list.push([move_id.to_s, move_id.to_s])
    end
    # Add common types without animations
    common_types = ["Shiny", "HealthUp", "HealthDown", "Fainted", "Flee", "Hurt", "Poison", "Burn", "Paralysis", "Frozen", "Sleep", "Confusion", "Infatuation", "StatUp", "StatDown"]
    common_types.each do |common|
      @common_list.push([common, common]) unless @common_animations[common.to_sym]
    end
    @common_list.uniq!
    @common_list.sort!
    # Remove duplicate animation names
    @move_animations.each_value { |anims| anims.uniq! { |a| a[1] } }
    @common_animations.each_value { |anims| anims.uniq! { |a| a[1] } }
  end

  def selected_move_animations
    val = @components.get_control(:moves_list).value
    return [] if !val
    key = val.is_a?(Array) ? val[0] : val
    return (@move_animations[key] || []) if @animation_type == 0
    return (@common_animations[key.to_sym] || []) if @animation_type == 1
    return []
  end

  def selected_animation_id
    return @components.get_control(:animations_list).value
  end

  #-----------------------------------------------------------------------------

  def refresh
    # Put the correct list into the moves list
    case @animation_type
    when 0
      @components.get_control(:moves).set_highlighted
      @components.get_control(:commons).set_not_highlighted
      @components.get_control(:moves_list).values = @move_list
      @components.get_control(:moves_label).text = _INTL("Moves")
    when 1
      @components.get_control(:moves).set_not_highlighted
      @components.get_control(:commons).set_highlighted
      @components.get_control(:moves_list).values = @common_list
      @components.get_control(:moves_label).text = _INTL("Animaciones Common")
    end
    # Put the correct list into the animations list
    @components.get_control(:animations_list).values = selected_move_animations
    # Enable/disable buttons depending on what is selected
    if @components.get_control(:animations_list).value
      @components.get_control(:edit).enable
      @components.get_control(:copy).enable
      @components.get_control(:delete).enable
    else
      @components.get_control(:edit).disable
      @components.get_control(:copy).disable
      @components.get_control(:delete).disable
    end
  end

  #-----------------------------------------------------------------------------

  def apply_button_press(button)
    case button
    when :quit
      @quit = true
      return   # Don't need to refresh the screen
    when :new
      move_val = @components.get_control(:moves_list).value
      move_id = move_val.is_a?(Array) ? move_val[0] : move_val
      new_anim = GameData::Animation.new_hash(@animation_type, move_id)
      new_id = (GameData::Animation.keys.max || 0) + 1
      new_anim[:pbs_path] = "NewAnimation_#{new_id}"
      screen = AnimationEditor.new(new_id, new_anim)
      screen.run
      generate_full_lists
    when :moves
      @animation_type = 0
      @components.get_control(:moves_list).selected = -1
      @components.get_control(:animations_list).selected = -1
    when :commons
      @animation_type = 1
      @components.get_control(:moves_list).selected = -1
      @components.get_control(:animations_list).selected = -1
    when :edit
      anim_id = selected_animation_id
      if anim_id
        screen = AnimationEditor.new(anim_id, GameData::Animation.get(anim_id).clone_as_hash)
        screen.run
        load_settings
        self.color_scheme = @settings[:color_scheme]
        generate_full_lists
      end
    when :copy
      anim_id = selected_animation_id
      if anim_id
        new_anim = GameData::Animation.get(anim_id).clone_as_hash
        new_anim[:name] += " " + _INTL("(copia)") if !nil_or_empty?(new_anim[:name])
        new_id = (GameData::Animation.keys.max || 0) + 1
        new_anim[:pbs_path] = "NewAnimation_#{new_id}"
        screen = AnimationEditor.new(new_id, new_anim)
        screen.run
        generate_full_lists
      end
    when :delete
      anim_id = selected_animation_id
      if anim_id && confirm_message(_INTL("¿Estás seguro de que quieres eliminar esta animación?"))
        pbs_path = GameData::Animation.get(anim_id).pbs_path
        GameData::Animation::DATA.delete(anim_id)
        if GameData::Animation::DATA.any? { |_key, anim| anim.pbs_path == pbs_path }
          Compiler.write_battle_animation_file(pbs_path)
        elsif FileTest.exist?("PBS/Animations/" + pbs_path + ".txt")
          File.delete("PBS/Animations/" + pbs_path + ".txt")
        end
        generate_full_lists
      end
    end
    refresh
  end

  def update
    @components.update
    if @components.changed?
      @components.values.each_pair do |property, value|
        apply_button_press(property)
      end
      @components.clear_changed
    end
    # Detect change to filter text
    filter_ctrl = @components.get_control(:filter)
    if filter_ctrl.value != @filter_text
      @filter_text = filter_ctrl.value
      apply_list_filter
      refresh
    end
  end

  def run
    Input.text_input = false
    loop do
      Graphics.update
      Input.update
      update
      break if !@components.busy? && @quit
    end
    dispose
  end
end
