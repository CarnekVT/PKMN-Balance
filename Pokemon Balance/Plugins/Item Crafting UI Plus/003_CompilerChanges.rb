module GameData
  class Recipe
    class << self
      alias _itemcrafter_load load
      def load
        _itemcrafter_load if File.exist?("Data/recipes.dat")
      end
    end
  end
end

module Compiler
  module_function
  #=============================================================================
  # Compile Recipes data
  #=============================================================================
    def compile_recipes(*paths)
    compile_PBS_file_generic(GameData::Recipe, *paths) do |final_validate, hash|
      (final_validate) ? validate_all_compiled_recipes : validate_compiled_recipe(hash)
    end
  end

  def validate_compiled_recipe(hash)
    if hash[:ingredients].nil?
      raise "The entry 'Ingredients' is required in recipes.txt section #{hash[:id]}."
    end
    hash[:ingredients].map! do |x|
      next [x[0].to_sym, x[1]] if GameData::Item.exists?(x[0].to_sym)
      next x
    end
  end

  # no specific validation required
  def validate_all_compiled_recipes
  end

  # _itemcrafter_original_compile_pbs_files = method(:compile_pbs_files)

  # def compile_pbs_files(text_files)
  #   _itemcrafter_original_compile_pbs_files.call(text_files)
  #   text_files[:Recipe] ||= ["recipes", []]
  #   compile_recipes(*text_files[:Recipe][1]) if text_files[:Recipe] && text_files[:Recipe][1] # Depends on Item
  # end
end