class CharactersController < ApplicationController

  def new
  end

  def create
    p "Character Params: ", character_params
    # new_character = Character.create(character_params)
    # new_character.update({name: character_name})
    backgrounds = JSON.parse(File.read(Dir.pwd + '/reference/backgrounds.json'))['backgrounds']
    character_classes = JSON.parse(File.read(Dir.pwd + '/reference/classes.json'))['classes']
    traits = JSON.parse(File.read(Dir.pwd + '/reference/traits.json'))['traits']
    skills = JSON.parse(File.read(Dir.pwd + '/reference/skills.json'))['skills']
    p "Character Background: ", character_params[:background]
    character_classes.keys.each do |c_class|
      if character_params[:character_class] == c_class
        traits.each do |trait|
          # character = new_character.id
          name = trait
          value = params[trait].to_i
          modifier = (value - 10)/2
          saving_throw = false
          saving_throw = true if character_classes[c_class]['saving throws'].include?(trait)
        #   Trait.create({name: name, value: value, modifier: modifier, character_id: character, saving_throw: saving_throw})
        end
        backgrounds.keys.each do |bg|
          if character_params[:background] == bg
            skills.each_pair do |skill, skill_trait|
              # character = new_character.id
              name = skill
              proficient = false
              proficient = true if params["skills_#{skill}"] != nil && params["skills_#{skill}"].include?(skill)
              proficient = true if backgrounds[bg]['skills'].include?(skill)
              p proficient
              # bonus = Trait.where({character_id: character, name: skill_trait}).first[:modifier]
            #   Skill.create({name: name, proficient: proficient, bonus: bonus, character_id: character})
            end
          end
        end
      end
    end
    flash[:notice] = "Params sent"
    # redirect_to profile_path
    redirect_to new_character_path
  end

  private

  def character_name
    character_params[:name].gsub(' ', '-')
  end

  def character_params
    params.require(:character).permit(:user_id, :name, :level, :exp, :gender, :race, :background, :character_class)
  end

end
