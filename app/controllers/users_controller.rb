class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:recruits_index, :favorite_index, :edit, :update, :my_page]

  def recruit_index
    @recruits = current_user.recruits.with_attached_images.page(params[:page]).per(10)
    @count = @recruits.total_count
  end

  def favorite_index
    @recruits = current_user.favorite_recruits.with_attached_images.page(params[:page]).per(10)
    @count = @recruits.total_count
  end

  def show
    @user = User.find(params[:id])
    user_applicant_recruits = Applicant.where(user_id: @user.id).map(&:recruit_id)
    @recruit_id = params[:recruit_id] || current_user.recruits.map(&:id).intersection(user_applicant_recruits)[0]
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

  def my_page
    @user = User.find(params[:user_id])
  end

  private

  # 正しいユーザーかどうかを確認
  def correct_user
    @user = User.find(params[:id]) if params[:id]
    @user = User.find(params[:user_id]) if params[:user_id]
    redirect_to(root_url) unless current_user == @user
  end

  def user_params
    params.require(:user).permit(:name, :profile_photo, :introduce)
  end
end
