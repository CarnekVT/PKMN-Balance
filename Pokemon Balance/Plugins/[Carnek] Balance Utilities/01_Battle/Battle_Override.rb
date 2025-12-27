class Battle
  def canSwitch
    return @rules["canSwitch"].nil? ? true : @rules["canSwitch"]
  end
end
