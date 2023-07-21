class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update]
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    new_image = params[:user][:images]
    @user.update_profile_image(new_image)
    if @user.update(user_params)
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  # 正しいユーザーかどうかを確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user == @user
  end

  def user_params
    params.require(:user).permit(:name, :profile_photo, :introduce)
  end
end
