class UsersController < ApplicationController
  before_action :verify_authorization

  def index
    @user = User.new
    @users = User.all
  end

  def create
    if User.create(user_params)
      flash[:notice] = 'User created'
    else
      flash[:alert] = 'User could not be created'
    end
    redirect_to users_path
  end

  def destroy
    if User.destroy(params[:id])
      flash[:notice] = 'User deleted'
    else
      flash[:alert] = 'User could not be deleted'
    end
    redirect_to users_path
  end

  private

  def verify_authorization
    unless %w[henri claudia test].include? current_user.username.downcase
      redirect_to root_path, alert: 'only claudia and henri have permission to manage users'
    end
  end

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
