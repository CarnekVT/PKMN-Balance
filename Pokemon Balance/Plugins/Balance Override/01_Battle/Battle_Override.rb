def pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers)
  # Drowsy
  if target.status == :DROWSY
    multipliers[:final_damage_multiplier] *= 4 / 3.0
  end
end  
