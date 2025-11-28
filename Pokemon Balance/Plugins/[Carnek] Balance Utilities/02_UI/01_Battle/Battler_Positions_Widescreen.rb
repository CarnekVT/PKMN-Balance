#===============================================================================
# [FIX FINAL] Battle System: INVERTIDO (1=Izquierda, 3=Derecha)
#===============================================================================

# ------------------------------------------------------------------------------
# PARTE 1: POSICIONES X/Y (Intercambio Final)
# ------------------------------------------------------------------------------
class Battle::Scene
  def self.pbBattlerPosition(idxBattler, sideSize = 1)
    # LADO DEL JUGADOR
    if (idxBattler & 1) == 0   
      base_y = 320 
      case sideSize
      when 1 then return [208, base_y]
      when 2 then return [[280, base_y + 4], [140, base_y]][idxBattler / 2]
      when 3 then return [[60, base_y], [210, base_y + 4], [360, base_y + 8]][idxBattler / 2]
      end

    # LADO DEL OPONENTE
    else   
      case sideSize
      when 1 then return [464, 200]
        
      when 2
        # FIX DOBLES: INVERTIDO

        if idxBattler == 1
          # ÍNDICE 1 (Charizard) -> A LA DERECHA (Frente)
          # X=560, Y=240
          return [560, 240]
        else
          # ÍNDICE 3 (Venusaur) -> A LA IZQUIERDA (Fondo)
          # X=360, Y=200
          return [360, 200]
        end
        
      when 3
        case idxBattler
        when 1 then return [550, 215]
        when 3 then return [440, 208]
        when 5 then return [330, 200]
        end
      end
    end
    return [0, 0]
  end
end

# ------------------------------------------------------------------------------
# PARTE 2: FORZADO DE CAPAS (Z-INDEX)
# El Pokémon de la DERECHA (Index 3) tapará al de la IZQUIERDA (Index 1)
# ------------------------------------------------------------------------------
class Battle::Scene
  alias gemini_reverse_fix_pbGraphicsUpdate pbGraphicsUpdate
  
  def pbGraphicsUpdate
    gemini_reverse_fix_pbGraphicsUpdate

    if @battle && @battle.pbSideSize(1) == 2

      # EN ESTA CONFIGURACIÓN INVERTIDA:
      # pokemon_1 = Índice 1 (DERECHA / Charizard)
      # pokemon_3 = Índice 3 (IZQUIERDA / Venusaur)

      sprite_der = @sprites["pokemon_1"]
      sprite_izq = @sprites["pokemon_3"]

      if sprite_der && sprite_izq && !sprite_der.disposed? && !sprite_izq.disposed?

        # LÓGICA DE CAPAS:
        # El de la DERECHA (Index 1) debe tapar al de la IZQUIERDA (Index 3).
        if sprite_der.z <= sprite_izq.z
          sprite_der.z = sprite_izq.z + 50
        end
      end
    end

    if @battle && @battle.pbSideSize(0) == 2

      # PARA EL JUGADOR: pokemon_0 derecha, pokemon_2 izquierda
      sprite_der = @sprites["pokemon_0"]
      sprite_izq = @sprites["pokemon_2"]

      if sprite_der && sprite_izq && !sprite_der.disposed? && !sprite_izq.disposed?

        # El de la DERECHA (Index 0) debe tapar al de la IZQUIERDA (Index 2).
        if sprite_der.z <= sprite_izq.z
          sprite_der.z = sprite_izq.z + 50
        end
      end
    end
  end
end