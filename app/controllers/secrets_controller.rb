class SecretsController < ApplicationController
  before_action :authenticate_user!
  def index
    @recruits = Recruit.active.with_attached_images.page(params[:page]).per(10)
    @count = @recruits.total_count
  end

  def search; end
end
