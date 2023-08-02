class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :current_user?

  def index
    current_user.notifications.where(read: false).each do |notification|
      notification.read = true
      notification.save if notification.valid?
    end
  end

  private

  def current_user?
    redirect_to root_path if current_user.id != params[:user_id].to_i
  end
end
