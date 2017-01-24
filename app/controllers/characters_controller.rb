class CharactersController < ApplicationController

  def new
    @fields = ['armor', 'backgrounds', 'equipment', 'gaming_sets', 'gods',
            'instruments', 'languages', 'levels', 'races', 'skills', 'spells',
            'tools', 'traits', 'trinkets', 'vehicles', 'weapons']
  end

  def create
    p "Character Params", character_params
    new_character = Character.create(character_params)
    new_character.update({name: character_name})
    p "Skills:", params["skills_Acrobatics"]
    traits = JSON.parse(File.read(Dir.pwd + '/reference/traits.json'))['traits']
    traits.each do |trait|
      character = new_character.id
      name = trait
      value = params[trait].to_i
      modifier = (value - 10)/2
      Trait.create({name: name, value: value, modifier: modifier, character_id: character})
    end
    skills = JSON.parse(File.read(Dir.pwd + '/reference/skills.json'))['skills']
    skills.each_pair do |skill, skill_trait|
      character = new_character.id
      name = skill
      proficient = false
      proficient = true if params["skills_#{skill}"] != nil && params["skills_#{skill}"].include?(skill)
      bonus = Trait.where({character_id: character, name: skill_trait}).first[:modifier]
      Skill.create({name: name, proficient: proficient, bonus: bonus, character_id: character})
    end
    flash[:notice] = "Params sent"
    redirect_to profile_path
  end

  private

  def character_name
    character_params[:name].gsub(' ', '-')
  end

  def character_params
    params.require(:character).permit(:user_id, :name, :level, :exp, :gender, :race, :background)
  end

end
