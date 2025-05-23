#===============================================================================
#
#===============================================================================
def pbLoadTrainer(tr_type, tr_name, tr_version = 0)
  tr_type_data = GameData::TrainerType.try_get(tr_type)
  raise _INTL("Trainer type {1} does not exist.", tr_type) if !tr_type_data
  tr_type = tr_type_data.id
  trainer_data = GameData::Trainer.try_get(tr_type, tr_name, tr_version)
  return (trainer_data) ? trainer_data.to_trainer : nil
end

def pbNewTrainer(tr_type, tr_name, tr_version, save_changes = true)
  party = []
  Settings::MAX_PARTY_SIZE.times do |i|
    if i == 0
      pbMessage(_INTL("Por favor introduce el primer Pokémon.", i))
    elsif !pbConfirmMessage(_INTL("¿Añadir otro Pokémon?"))
      break
    end
    loop do
      species = pbChooseSpeciesList
      if species
        params = ChooseNumberParams.new
        params.setRange(1, GameData::GrowthRate.max_level)
        params.setDefaultValue(10)
        level = pbMessageChooseNumber(_INTL("Elige el nivel para {1} (máx. {2}).",
                                            GameData::Species.get(species).name, params.maxNumber), params)
        party.push([species, level])
        break
      else
        break if i > 0
        pbMessage(_INTL("¡Este entrenador debe tener al menos 1 Pokémon!"))
      end
    end
  end
  trainer = [tr_type, tr_name, [], party, tr_version]
  if save_changes
    trainer_hash = {
      :trainer_type => tr_type,
      :real_name    => tr_name,
      :version      => tr_version,
      :pokemon      => []
    }
    party.each do |pkmn|
      trainer_hash[:pokemon].push(
        {
          :species => pkmn[0],
          :level   => pkmn[1]
        }
      )
    end
    # Add trainer's data to records
    trainer_hash[:id] = [trainer_hash[:trainer_type], trainer_hash[:real_name], trainer_hash[:version]]
    GameData::Trainer.register(trainer_hash)
    GameData::Trainer.save
    pbConvertTrainerData
    pbMessage(_INTL("Los datos del Entrenador han sido añadidos a la lista de batallas y en PBS/trainers.txt."))
  end
  return trainer
end

def pbConvertTrainerData
  tr_type_names = []
  GameData::TrainerType.each { |t| tr_type_names.push(t.real_name) }
  MessageTypes.setMessagesAsHash(MessageTypes::TRAINER_TYPE_NAMES, tr_type_names)
  Compiler.write_trainer_types
  Compiler.write_trainers
end

def pbTrainerTypeCheck(trainer_type)
  return true if !$DEBUG
  return true if GameData::TrainerType.exists?(trainer_type)
  if pbConfirmMessage(_INTL("¿Añadir nuevo tipo de entrenador {1}?", trainer_type.to_s))
    pbTrainerTypeEditorNew(trainer_type.to_s)
  end
  pbMapInterpreter&.command_end
  return false
end

# Called from trainer events to ensure the trainer exists
def pbTrainerCheck(tr_type, tr_name, max_battles, tr_version = 0)
  return true if !$DEBUG
  # Check for existence of trainer type
  pbTrainerTypeCheck(tr_type)
  tr_type_data = GameData::TrainerType.try_get(tr_type)
  return false if !tr_type_data
  tr_type = tr_type_data.id
  # Check for existence of trainer with given ID number
  return true if GameData::Trainer.exists?(tr_type, tr_name, tr_version)
  # Add new trainer
  if pbConfirmMessage(_INTL("¿Añadir nueva variante de entrenador {1} (de {2}) para {3} {4}?",
                            tr_version, max_battles, tr_type.to_s, tr_name))
    pbNewTrainer(tr_type, tr_name, tr_version)
  end
  return true
end

def pbGetFreeTrainerParty(tr_type, tr_name)
  tr_type_data = GameData::TrainerType.try_get(tr_type)
  raise _INTL("El tipo de entrenador {1} no existe.", tr_type) if !tr_type_data
  tr_type = tr_type_data.id
  256.times do |i|
    return i if !GameData::Trainer.try_get(tr_type, tr_name, i)
  end
  return -1
end

def pbMissingTrainer(tr_type, tr_name, tr_version)
  tr_type_data = GameData::TrainerType.try_get(tr_type)
  raise _INTL("El tipo de entrenador {1} no existe.", tr_type) if !tr_type_data
  tr_type = tr_type_data.id
  if !$DEBUG
    raise _INTL("No se encuentra el entrenador ({1}, {2}, ID {3})", tr_type.to_s, tr_name, tr_version)
  end
  message = ""
  if tr_version == 0
    message = _INTL("¿Añadir nuevo entrenador ({1}, {2})?", tr_type.to_s, tr_name)
  else
    message = _INTL("¿Añadir nuevo entrenador ({1}, {2}, ID {3})?", tr_type.to_s, tr_name, tr_version)
  end
  cmd = pbMessage(message, [_INTL("Sí"), _INTL("No")], 2)
  pbNewTrainer(tr_type, tr_name, tr_version) if cmd == 0
  return cmd
end
