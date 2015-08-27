class UsersController < ApplicationController
  
  before_action :load_user

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "User #{@user.email} has been updated"
      redirect_to root_path    
    else
      flash[:error] = @user.errors.to_a.join(";") if @user.errors.any?
      redirect_to :back
    end
  end

  def destroy
    if @user.destroy
      redirect_to root_path
      flash[:success] = "User has been deleted"
    end
  end  

  def ban
    if @user.update(banned: true)
      flash[:success] = "User #{@user.email} has been banned"
      redirect_to :back
    else
      flash[:notice] = "User #{@user.email} has not been banned"
      redirect_to root_path
    end
  end  

  def unban
    if @user.update(banned: false)
      flash[:success] = "User #{@user.email} has been unbanned"
      redirect_to :back
    else
      flash[:notice] = "User #{@user.email} has not been unbanned"
      redirect_to root_path
    end
  end

  def account_update_params
    devise_parameter_sanitizer.sanitize(:account_update)
  end

  private

  def load_user
      @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end