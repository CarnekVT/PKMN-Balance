#===============================================================================
#
#                   Sprites Animados para Essentials básico
#                      adaptado por DPertierra y Skyflyer
#
#
#  Script original: Luka S.J.
#  Distribuido por: Tenshi of War
#
#  Por favor, asegúrate de leer todas las instrucciones necesarias sobre cómo
#  instalar y usar este script correctamente.
#  Instrucciones dadas en la página de recursos de este script:
#  https://reliccastle.com/resources/568/
#
#===============================================================================
#
#                              Notas Adicionales
#
#  1. Para usar este script, debes elegir el tamaño de los sprites indicando el valo
#     en las variables FRONTSPRITE_SCALE y BACKSPRITE_SCALE, que están aquí abajo.
#     Por defecto se usa 2 para los sprites rivales y 3 para los del jugador.
#
#  2. Para cambiar las posiciones de los sprites debes hacerlo desde el menú debug,
#     pulsando en la opción de "Editor de archivos PBS" y ahí dentro en "editar el
#     archivo pokémon_metrics.txt".
#
#  3. Puedes elegir la velocidad a la que se mueven los sprites con las variables:
#     @ Speed, un valor de 0 a 3 (determina la velocidad de la animación)
#     @ Skip, un entero (determina cuántos fotogramas saltar)
#     Para editar estos valores, ve a las siguientes líneas de código:
#     @ Velocidad ==> 56
#     @ Skip  ==> 73
#
#===============================================================================
#===============================================================================

# ELIGE EL MULTIPLICADOR DEL TAMAÑO DE LOS POKÉMON

FRONTSPRITE_SCALE = 2
BACKSPRITE_SCALE  = 3

#===============================================================================

class PokemonSystem
    attr_accessor :animated_sprites
end

class BitmapWrapperEX
    attr_reader :width, :height, :totalFrames, :animationFrames, :currentIndex
    attr_accessor :constrict, :scale, :frameSkip
    #-----------------------------------------------------------------------------
    @@disableBitmapAnimation = false
    #-----------------------------------------------------------------------------
    #  class constructor
    #-----------------------------------------------------------------------------
    def initialize(file, scale = 2, skip = 3)
        # failsafe checks
        raise "filename is nil" if file == nil
        raise ".gif files are not supported!" if File.extname(file) == ".gif"
        #---------------------------------------------------------------------------
        @scale = scale
        @constrict = nil
        @width = 0
        @height = 0
        @frame = 0
        @frames = 2
        @frameSkip = skip
        @direction = 1
        @animationFinish = false
        @totalFrames = 0
        @currentIndex = 0
        @changed_hue = false
        @speed = 1
        # 0 - no se mueven
        # 1 - velocidad normal
        # 2 - velocidad media
        # 3 - velocidad lenta
        
        @bitmapFile = pbBitmap(file)
        # initializes full Pokemon bitmap
        @@disableBitmapAnimation = ($PokemonSystem.animated_sprites == 1) # 1 = false, 0 = true
        @bitmap = Bitmap.new(@bitmapFile.width,@bitmapFile.height)

        @bitmap.blt(0,0,@bitmapFile,@bitmapFile.rect)
        @width = @bitmapFile.height*@scale
        @height = @bitmap.height*@scale
        #---------------------------------------------------------------------------
        self.refresh
        #---------------------------------------------------------------------------
        @actualBitmap = Bitmap.new(@width,@height)
        @actualBitmap.clear
        @actualBitmap.stretch_blt(Rect.new(0,0,@width,@height),@bitmap,Rect.new(@currentIndex*(@width/@scale),0,@width/@scale,@height/@scale))
    end
    #-----------------------------------------------------------------------------
    #  returns proper object values when requested
    #-----------------------------------------------------------------------------
    def length; @totalFrames; end
    def disposed?; @actualBitmap.disposed?; end
    def dispose
        @bitmap.dispose
        @bitmapFile.dispose
        @actualBitmap.dispose
    end
    def copy; @actualBitmap.clone; end
    def bitmap; @actualBitmap; end
    def bitmap=(val); @actualBitmap=val; end
    def each; end
    def alterBitmap(index); return @strip[index]; end
    #-----------------------------------------------------------------------------
    #  preparation and compiling of spritesheet for sprite alterations
    #-----------------------------------------------------------------------------
    def prepareStrip
        @strip = []
        for i in 0...@totalFrames
        bitmap = Bitmap.new(@width,@height)
        bitmap.stretch_blt(Rect.new(0,0,@width,@height),@bitmapFile,Rect.new((@width/@scale)*i,0,@width/@scale,@height/@scale))
        @strip.push(bitmap)
        end
    end
    def compileStrip
        @bitmap.clear
        for i in 0...@strip.length
        @bitmap.stretch_blt(Rect.new((@width/@scale)*i,0,@width/@scale,@height/@scale),@strip[i],Rect.new(0,0,@width,@height))
        end
    end
    #-----------------------------------------------------------------------------
    #  creates custom loop if defined in data
    #-----------------------------------------------------------------------------
    def compileLoop(data)
        r = @bitmapFile.height; w = 0; x = 0
        @bitmap.clear
        # calculate total bitmap width
        for p in data
        w += p[:range].to_a.length * p[:repeat] * r
        end
        # create new bitmap
        @bitmap = Bitmap.new(w,r)
        # compile strip from data
        for m in 0...data.length
        range = data[m][:range].to_a
        repeat = data[m][:repeat]
        # offset based on previous frames
        x += m > 0 ? (data[m-1][:range].to_a.length * data[m-1][:repeat] * r) : 0
        for i in 0...repeat
            for j in 0...range.length
            x0 = x + (i*range.length*r) + (j*r)
            # draws frame from repeated ranges
            @bitmap.blt(x0,0,@bitmapFile,Rect.new(range[j]*r,0,r,r))
            end
        end
        end
        self.refresh
    end
    #-----------------------------------------------------------------------------
    #  refreshes the metric parameters
    #-----------------------------------------------------------------------------
    def refresh
        # calculates the total number of frames
        @totalFrames = (@bitmap.width.to_f/@bitmap.height).ceil
        @animationFrames = @totalFrames*@frames
    end
    #-----------------------------------------------------------------------------
    #  reverses the animation
    #-----------------------------------------------------------------------------
    def reverse
        if @direction  >  0
        @direction = -1
        elsif @direction < 0
        @direction = +1
        end
    end
    #-----------------------------------------------------------------------------
    #  sets speed of animation
    #-----------------------------------------------------------------------------
    def setSpeed(value)
        @speed = value
    end
    #-----------------------------------------------------------------------------
    #  jumps animation to specific frame
    #-----------------------------------------------------------------------------
    def toFrame(frame)
        # checks if specified string parameter
        if frame.is_a?(String)
        if frame == "last"
            frame = @totalFrames - 1
        else
            frame = 0
        end
        end
        # sets frame
        frame = @totalFrames - 1 if frame >= @totalFrames
        frame = 0 if frame < 0
        @currentIndex = frame
        # draws frame
        @actualBitmap.clear
        x, y, w, h = self.box
        @actualBitmap.stretch_blt(Rect.new(x,y,w,h), @bitmap, Rect.new(@currentIndex*(@width/@scale)+x/@scale, y/@scale, w/@scale, h/@scale))
    end
    #-----------------------------------------------------------------------------
    #  changes the hue of the bitmap
    #-----------------------------------------------------------------------------
    def hue_change(value)
        @bitmap.hue_change(value)
        @changed_hue = true
    end
    def changedHue?; return @changed_hue; end
    #-----------------------------------------------------------------------------
    #  performs animation loop once
    #-----------------------------------------------------------------------------
    def play
        return if self.finished?
        self.update
    end
    #-----------------------------------------------------------------------------
    #  checks if animation is finished
    #-----------------------------------------------------------------------------
    def finished?
        return (@currentIndex >= @totalFrames - 1)
    end
    #-----------------------------------------------------------------------------
    #  fetches the constraints for the sprite
    #-----------------------------------------------------------------------------
    def box
        x = (@constrict.nil? || @width <= @constrict) ? 0 : ((@width-@constrict)/2.0).ceil
        y = (@constrict.nil? || @width <= @constrict) ? 0 : ((@height-@constrict)/2.0).ceil
        w = (@constrict.nil? || @width <= @constrict) ? @width : @constrict
        h = (@constrict.nil? || @width <= @constrict) ? @height : @constrict
        return x, y, w, h
    end
    #-----------------------------------------------------------------------------
    #  performs sprite animation
    #-----------------------------------------------------------------------------
    def update
        return false if @@disableBitmapAnimation
        return false if @actualBitmap.disposed?
        return false if @speed < 1
        case @speed
        # frame skip
        when 2
        @frames = 4
        when 3
        @frames = 5
        else
        @frames = 2
        end
        @frame += 1
        if @frame >= @frames*@frameSkip
        # processes animation speed
        @currentIndex += @direction
        @currentIndex = 0 if @currentIndex >= @totalFrames
        @currentIndex = @totalFrames - 1 if @currentIndex < 0
        @frame = 0
        end
        # updates actual bitmap
        @actualBitmap.clear
        # applies constraint if applicable
        x, y, w, h = self.box
        @actualBitmap.stretch_blt(Rect.new(x,y,w,h), @bitmap, Rect.new(@currentIndex*(@width/@scale)+x/@scale, y/@scale, w/@scale, w/@scale))
    end
    #-----------------------------------------------------------------------------
    #  returns bitmap to original state
    #-----------------------------------------------------------------------------
    def deanimate
        @frame = 0
        @currentIndex = 0
        @actualBitmap.clear
        # applies constraint if applicable
        x, y, w, h = self.box
        @actualBitmap.stretch_blt(Rect.new(x,y,w,h), @bitmap, Rect.new(@currentIndex*(@width/@scale)+x/@scale, y/@scale, w/@scale, h/@scale))
    end
end
#-----------------------------------------------------------------------------

module GameData
    class Species
        def self.front_sprite_filename(species, form = 0, gender = 0, shiny = false, shadow = false)
            return self.check_graphic_file("Graphics/Pokemon/", species, form, gender, shiny, shadow, "Front")
        end
      
        def self.back_sprite_filename(species, form = 0, gender = 0, shiny = false, shadow = false)
            return self.check_graphic_file("Graphics/Pokemon/", species, form, gender, shiny, shadow, "Back")
        end


        def self.front_sprite_bitmap(species, form = 0, gender = 0, shiny = false, shadow = false)
            filename = self.front_sprite_filename(species, form, gender, shiny, shadow)
            return (filename) ? BitmapWrapperEX.new(filename, FRONTSPRITE_SCALE) : nil 
        end
        
        def self.back_sprite_bitmap(species, form = 0, gender = 0, shiny = false, shadow = false)
            filename = self.back_sprite_filename(species, form, gender, shiny, shadow)
            return (filename) ? BitmapWrapperEX.new(filename, BACKSPRITE_SCALE) : nil 
        end

        def self.sprite_bitmap_from_pokemon(pkmn, back = false, species = nil)
            species = pkmn.species if !species
            species = GameData::Species.get(species).species   # Just to be sure it's a symbol
            return self.egg_sprite_bitmap(species, pkmn.form) if pkmn.egg?
            if back
              ret = self.back_sprite_bitmap(species, pkmn.form, pkmn.gender, pkmn.shiny?, pkmn.shadowPokemon?)
            else
              ret = self.front_sprite_bitmap(species, pkmn.form, pkmn.gender, pkmn.shiny?, pkmn.shadowPokemon?)
            end
            alter_bitmap_function = MultipleForms.getFunction(species, "alterBitmap")
            if ret && alter_bitmap_function
              new_ret = BitmapWrapperEX.copy
              BitmapWrapperEX.dispose
              new_ret.each { |bitmap| alter_bitmap_function.call(pkmn, bitmap) }
              ret = new_ret
            end
            return ret
        end
    end
end

MenuHandlers.add(:options_menu, :animated_sprites, {
  "name"        => _INTL("Sprites Animados"),
  "order"       => 40,
  "type"        => EnumOption,
  "parameters"  => [_INTL("Sí"), _INTL("No")],
  "description" => _INTL("Elige si quieres que los sprites de los Pokémon estén animados en combate."),
  "get_proc"    => proc { next $PokemonSystem.animated_sprites },
  "set_proc"    => proc { |value, _scene| $PokemonSystem.animated_sprites = value }
})