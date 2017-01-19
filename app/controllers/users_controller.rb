class UsersController < ApplicationController

  def new
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to profile_path
    else
      flash[:error] = user.errors.full_messages.join("\n")
      redirect_to signup_path
    end
  end

  def profile
    @skills
    @traits
    json_files = ['skills', 'traits', 'armor_proficiencies', 'weapon_proficiencies', 'language_proficiencies', 'tool_proficiencies', 'instrument_proficiencies', 'gaming_set_proficiencies', 'vehicle_proficiencies', 'backgrounds']
    json_files.each do |path|
      file = File.read(Dir.pwd + "/reference/#{path}.json")
      data_hash = JSON.parse(file)
      @skills = data_hash["#{path}"] if path == 'skills'
      @traits = data_hash["#{path}"] if path == 'traits'
      @backgrounds = data_hash["#{path}"] if path == 'backgrounds'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :about_me)
  end

end
