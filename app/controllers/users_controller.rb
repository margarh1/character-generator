class UsersController < ApplicationController

  before_action :already_signed_in, only: [:new, :create]
  before_action :authorize, only: [:profile]

  def new
  end

  def create
    user = User.new(user_params)
    if user.save
      flash[:success] = 'Successfully signed up!'
      session[:user_id] = user.id
      redirect_to profile_path
    else
      flash[:error] = user.errors.full_messages.join("\n")
      redirect_to signup_path
    end
  end

  def show
    @user = User.find_by_username(username)
  end

  def profile
    @user = User.find(current_user)
  end

  def edit
  end

  def update
  end

  def destroy
    User.destroy(current_user)
    session[:user_id] = nil
    redirect_to signup_path
  end

  private

  def username
    params[:username]
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :about_me)
  end

end
