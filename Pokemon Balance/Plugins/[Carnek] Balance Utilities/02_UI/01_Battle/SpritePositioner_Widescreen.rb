#===============================================================================
# [FIX] Parches de Corrección para Widescreen (640x480) - V3 (Aggressive Sort)
#===============================================================================

# ------------------------------------------------------------------------------
# PARTE 1: CORRECCIÓN VISUAL (Posiciones de los Sprites)
# ------------------------------------------------------------------------------
class Battle::Scene
  def self.pbBattlerPosition(idxBattler, sideSize = 1)
    # LADO DEL JUGADOR (Índices 0, 2, 4)
    if (idxBattler & 1) == 0   
      base_y = 320 
      case sideSize
      when 1
        return [208, base_y]
      when 2
        return [[280, base_y + 4], [140, base_y]][idxBattler / 2]
      when 3
        return [[60, base_y], [210, base_y + 4], [360, base_y + 8]][idxBattler / 2]
      end

    # LADO DEL OPONENTE (Índices 1, 3, 5)
    else   
      case sideSize
      when 1
        return [464, 200]
      when 2
        # FIX DOBLES: Invertido - Skitty (1) Derecha, Spearow (3) Izquierda
        if idxBattler == 1
          return [520, 204]
        else
          return [400, 200]
        end
      when 3
        # FIX TRIPLES: Prioridad escalonada
        case idxBattler
        when 1 then return [550, 208]  # Derecha
        when 3 then return [440, 204]  # Centro
        when 5 then return [330, 200]  # Izquierda
        end
      end
    end
    return [0, 0]
  end
end

# ------------------------------------------------------------------------------
# PARTE 2: CORRECCIÓN LÓGICA (Orden de los Botones)
# ------------------------------------------------------------------------------
class Battle
  # Guardamos la función original
  alias :gemini_sort_v3_allOtherSideBattlers :allOtherSideBattlers

  # Interceptamos la llamada para ordenar la lista SIEMPRE
  def allOtherSideBattlers(*args)
    # 1. Obtenemos la lista original (sin importar argumentos)
    targets = gemini_sort_v3_allOtherSideBattlers(*args)

    # 2. Si la lista tiene contenido, la ordenamos por índice numérico.
    # Esto fuerza a que el índice 1 (Izquierda) siempre vaya antes del 3 (Derecha).
    if targets && targets.is_a?(Array) && targets.length > 1
      targets.sort! { |a, b| a.index <=> b.index }
    end

    return targets
  end
end