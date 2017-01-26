class CharactersController < ApplicationController

  def new
    @races = JSON.parse(File.read(Dir.pwd + "/reference/races.json"))['races'].keys
    @races.concat(['Dwarf - Hill', 'Dwarf - Mountain', 'Elf - High', 'Elf - Wood', 'Elf - Drow', 'Halfling - Lightfoot', 'Halfling - Stout', 'Gnome - Forest', 'Gnome - Rock'])
    @traits = JSON.parse(File.read(Dir.pwd + '/reference/traits.json'))['traits']
    @backgrounds = JSON.parse(File.read(Dir.pwd + "/reference/backgrounds.json"))['backgrounds'].keys
    @classes = JSON.parse(File.read(Dir.pwd + "/reference/classes.json"))['classes'].keys
    @skills = JSON.parse(File.read(Dir.pwd + '/reference/skills.json'))['skills'].keys
  end

  def create
    new_character = Character.create(character_params)
    new_character.update({name: character_name})
    levels = JSON.parse(File.read(Dir.pwd + '/reference/levels.json'))['levels']
    backgrounds = JSON.parse(File.read(Dir.pwd + '/reference/backgrounds.json'))['backgrounds']
    character_classes = JSON.parse(File.read(Dir.pwd + '/reference/classes.json'))['classes']
    traits = JSON.parse(File.read(Dir.pwd + '/reference/traits.json'))['traits']
    skills = JSON.parse(File.read(Dir.pwd + '/reference/skills.json'))['skills']
    # drilling into the class for saving throws
    character_classes.keys.each do |c_class|
      if character_params[:character_class] == c_class
        traits.each do |trait|
          character = new_character.id
          name = trait
          value = params[trait].to_i
          modifier = (value - 10)/2
          saving_throw = false
          saving_throw = true if character_classes[c_class]['saving throws'].include?(trait)
          Trait.create({name: name, value: value, modifier: modifier, character_id: character, saving_throw: saving_throw})
        end
        # drilling into the backgrounds for modifiers to skills
        backgrounds.keys.each do |bg|
          if character_params[:background] == bg
            skills.each_pair do |skill, skill_trait|
              character = new_character.id
              name = skill
              proficient = false
              proficient = true if params["skills_#{skill}"] != nil && params["skills_#{skill}"].include?(skill)
              proficient = true if backgrounds[bg]['skills'].include?(skill)
              bonus = Trait.where({character_id: character, name: skill_trait}).first[:modifier]
              bonus = Trait.where({character_id: character, name: skill_trait}).first[:modifier] + levels[new_character[:level].to_s]['proficiency bonus'] if proficient
              Skill.create({name: name, proficient: proficient, bonus: bonus, character_id: character})
            end
          end
        end
      end
    end
    flash[:success] = "#{new_character.name.gsub('-', ' ')} was created!"
    redirect_to profile_path
  end

  def generate
    @races = JSON.parse(File.read(Dir.pwd + "/reference/races.json"))['races'].keys
    @races.concat(['Dwarf - Hill', 'Dwarf - Mountain', 'Elf - High', 'Elf - Wood', 'Elf - Drow', 'Halfling - Lightfoot', 'Halfling - Stout', 'Gnome - Forest', 'Gnome - Rock'])
    @traits = JSON.parse(File.read(Dir.pwd + '/reference/traits.json'))['traits']
    @backgrounds = JSON.parse(File.read(Dir.pwd + "/reference/backgrounds.json"))['backgrounds']
    @classes = JSON.parse(File.read(Dir.pwd + "/reference/classes.json"))['classes'].keys
    @skills = JSON.parse(File.read(Dir.pwd + '/reference/skills.json'))['skills'].keys

    # rolling stats
    d6 = [1,2,3,4,5,6]
    trait_rolls = []
    6.times do
      roll = []
      num = 0
      4.times {roll << d6.shuffle.first}
      roll.sort!.reverse!
      3.times {|n| num += roll[n]}
      trait_rolls << num
      trait_rolls.sort!.reverse!
    end

    # picking race, gender, and class
    c_race = @races.shuffle.first
    c_subrace = c_race.split(' - ').last
    c_race = c_race.split(' - ').first
    c_gender = ['Male', 'Female'].shuffle.first
    c_class = @classes.shuffle.first
    c_name = 'placeholder'

    # generating name
    names = JSON.parse(File.read(Dir.pwd + '/reference/races.json'))['races'][c_race]['names']
    if c_race == 'Half-elf'
      find_names = names
      first_names = []
      last_names = []
      find_names.each do |name|
        if name == 'Elf'
          first_names.concat(JSON.parse(File.read(Dir.pwd + '/reference/races.json'))['races'][name]['names'][c_gender.downcase])
          last_names.concat(JSON.parse(File.read(Dir.pwd + '/reference/races.json'))['races'][name]['names']['surnames'])
        elsif name == 'Human'
          ethnicities = JSON.parse(File.read(Dir.pwd + '/reference/races.json'))['races'][name]['names'].keys
          ethnicities.each do |ethnicity|
            first_names.concat(JSON.parse(File.read(Dir.pwd + '/reference/races.json'))['races'][name]['names'][ethnicity][c_gender.downcase]) if ethnicity != 'Tethyrian'
            last_names.concat(JSON.parse(File.read(Dir.pwd + '/reference/races.json'))['races'][name]['names'][ethnicity]['surnames']) if ethnicity != 'Tethyrian'
          end
        end
      end
      first = first_names.shuffle.first
      last = last_names.shuffle.first
      c_name = first + ' ' + last
    elsif c_race == 'Half-orc'
      c_name = names[c_gender.downcase].shuffle.first
    elsif c_race == 'Human'
      ethnicities = names.keys
      first_names = []
      last_names = []
      ethnicities.each do |ethnicity|
        first_names.concat(JSON.parse(File.read(Dir.pwd + '/reference/races.json'))['races'][c_race]['names'][ethnicity][c_gender.downcase]) if ethnicity != 'Tethyrian'
        last_names.concat(JSON.parse(File.read(Dir.pwd + '/reference/races.json'))['races'][c_race]['names'][ethnicity]['surnames']) if ethnicity != 'Tethyrian'
      end
      c_name = first_names.shuffle.first + ' ' + last_names.shuffle.first
    elsif c_race == 'Tiefling'
      first_names = []
      concepts = []
      first_names.concat(JSON.parse(File.read(Dir.pwd + '/reference/races.json'))['races'][c_race]['names'][c_gender.downcase])
      concepts.concat(JSON.parse(File.read(Dir.pwd + '/reference/races.json'))['races'][c_race]['names']['concept'])
      c_name = first_names.shuffle.first + ' ' + concepts.shuffle.first
    else
      first = names[c_gender.downcase].shuffle.first
      last = names['surnames'].shuffle.first if !['Human', 'Half-elf', 'Half-orc', 'Tiefling'].include?(c_race)
      c_name = first + ' ' + last
    end

    # assigning values to traits according to the background's quick build suggestion
    str = 10
    dex = 10
    con = 10
    int = 10
    wis = 10
    cha = 10
    c_background = 'placeholder'
    changed = []
    quick_build = JSON.parse(File.read(Dir.pwd + '/reference/classes.json'))['classes'][c_class]['quick build']
    quick_build.each_pair do |step, val|
      if val.include?('/') && step != 'background'
        traits = val.split('/')
        trait = traits.shuffle.first.downcase
        str = trait_rolls.shift if trait == 'Strength'
        dex = trait_rolls.shift if trait == 'Dexterity'
        con = trait_rolls.shift if trait == 'Constitution'
        int = trait_rolls.shift if trait == 'Intelligence'
        wis = trait_rolls.shift if trait == 'Wisdom'
        cha = trait_rolls.shift if trait == 'Charisma'
        changed << trait.capitalize
      elsif step != 'background'
        str = trait_rolls.shift if quick_build[step] == 'Strength'
        dex = trait_rolls.shift if quick_build[step] == 'Dexterity'
        con = trait_rolls.shift if quick_build[step] == 'Constitution'
        int = trait_rolls.shift if quick_build[step] == 'Intelligence'
        wis = trait_rolls.shift if quick_build[step] == 'Wisdom'
        cha = trait_rolls.shift if quick_build[step] == 'Charisma'
        changed << quick_build[step]
      end
      c_background = val if step == 'background'
    end

    # distributing the rest of the rolls
    @traits.each do |trait|
      if !changed.include?(trait)
        str = trait_rolls.shift if trait == 'Strength'
        dex = trait_rolls.shift if trait == 'Dexterity'
        con = trait_rolls.shift if trait == 'Constitution'
        int = trait_rolls.shift if trait == 'Intelligence'
        wis = trait_rolls.shift if trait == 'Wisdom'
        cha = trait_rolls.shift if trait == 'Charisma'
      end
    end

    @generated_stats = [['Strength', str], ['Dexterity', dex], ['Constitution', con], ['Intelligence', int], ['Wisdom', wis], ['Charisma', cha]]
    @generated_character = Character.new({user_id: current_user.id, name: c_name, level: 1, exp: 0, gender: c_gender, race: c_race, background: c_background, character_class: c_class})
    p @generated_stats
    p @generated_character
    # render create
  end

  def destroy
    Character.find_by_name(params[:name].gsub(' ', '-')).destroy
    redirect_to profile_path
  end

  private

  def character_name
    character_params[:name].gsub(' ', '-')
  end

  def character_params
    params.require(:character).permit(:user_id, :name, :level, :exp, :gender, :race, :background, :character_class)
  end

end
