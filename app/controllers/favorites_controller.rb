class FavoritesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :recruit_params, only: [:create, :destroy]

  def create
    if Favorite.create(user_id: current_user.id, recruit_id: @recruit.id)
      Notification.create(sender_id: current_user.id, receiver_id: @recruit.user.id, category: 'favorite', recruit_id: @recruit.id) if current_user != @recruit.user
      respond_to do |format|
        format.html { redirect_to @recruit }
        format.js
      end
    end
  end

  def destroy
    favorite = Favorite.find_by(user_id: current_user.id, recruit_id: @recruit.id)
    if favorite.destroy
      respond_to do |format|
        format.html { redirect_to @recruit }
        format.js
      end
    end
  end

  private

  def recruit_params
    @recruit = Recruit.find(params[:recruit_id])
  end
end
