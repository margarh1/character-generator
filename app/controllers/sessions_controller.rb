class SessionsController < ApplicationController

  before_action :already_signed_in, only: [:new, :create]
  before_action :authorize, only: [:reference]

  def root
    redirect_to signup_path
  end

  def new
  end

  def create
    user = User.find_by_username(username)
    if user && user.authenticate(password)
      flash[:success] = 'Successfully signed in!'
      session[:user_id] = user.id
      redirect_to profile_path
    else
      flash[:error] = 'This user does not exist.' if user == nil
      flash[:error] = 'The username and password do not match.' if user != nil
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'Successfully logged out!'
    redirect_to login_path
  end

  def nonexistent
    flash[:notice] = "#{URI.decode(request.env['PATH_INFO'])} does not exist."
    redirect_to profile_path
  end

  def reference
    @file = File.read(Dir.pwd + "/reference/#{params[:title]}.json")
    render :json => @file
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
