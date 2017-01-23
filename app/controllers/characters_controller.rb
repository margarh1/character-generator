class CharactersController < ApplicationController

  def new
    @fields = ['armor', 'backgrounds', 'equipment', 'gaming_sets', 'gods',
            'instruments', 'languages', 'levels', 'races', 'skills', 'spells',
            'tools', 'traits', 'trinkets', 'vehicles', 'weapons']
  end

  def create
    new_character = Character.create(character_params)
    traits = ['Strength', 'Dexterity', 'Constitution', 'Intelligence', 'Wisdom', 'Charisma']
    traits.each do |trait|
      character = new_character.id
      name = trait
      value = params[trait].to_i
      modifier = (value - 10)/2
      Trait.create({name: name, value: value, modifier: modifier, character_id: character})
    end
    flash[:notice] = "Params sent"
    redirect_to new_character_path
  end

  private

  def character_params
    params.require(:character).permit(:user_id, :name, :background, :race, :character_class, :exp)
  end

end
