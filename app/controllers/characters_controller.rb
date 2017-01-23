class CharactersController < ApplicationController

  def new
    @fields = ['armor', 'backgrounds', 'equipment', 'gaming_sets', 'gods',
            'instruments', 'languages', 'levels', 'races', 'skills', 'spells',
            'tools', 'traits', 'trinkets', 'vehicles', 'weapons']
  end

  def create
    p 'Character Params:', character_params
    new_character = Character.create(character_params)
    traits = ['Strength', 'Dexterity', 'Constitution', 'Intelligence', 'Wisdom', 'Charisma']
    traits.each do |trait|
      character = new_character.id
      name = trait
      value = params[trait].to_i
      modifier = (value - 10)/2
      p [name, value, modifier, character]
      # Trait.create({name: name, value: value, modifier: modifier, character_id: character})
    end
    flash[:notice] = "Params sent"
    redirect_to new_character_path
  end

  private

  def character_params
    params.require(:character).permit(:name, :level, :background, :race, :class, :exp)
  end

end
