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

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :about_me)
  end

end
