class SessionsController < ApplicationController

  before_action :already_signed_in, except: [:destroy]

  def new
  end

  def create
    user = User.find_by_username(username)
    if user && user.authenticate(password)
      session[:user_id] = user.id
      redirect_to profile_path
    else
      flash[:error] = user.errors.full_messages.join("\n") if user != nil
      flash[:error] = 'This user does not exist.' if user == nil
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end

  private

  def username
    user_params[:username]
  end

  def password
    user_params[:password]
  end

  def user_params
    params.require(:user).permit(:username, :password)
  end

end
