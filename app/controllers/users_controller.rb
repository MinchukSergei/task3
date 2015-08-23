class UsersController < ApplicationController
  
  before_action :load_user

  def edit
  end

  def update
    @user.update(user_params)
    redirect_to root_path
  end

  def destroy
    @user.destroy
    redirect_to root_path
  end  

  def ban
    @user.update(banned: true)
    redirect_to :back
  end  

  def unban
    @user.update(banned: false)
    redirect_to :back
  end  

  private

  def load_user
      @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end