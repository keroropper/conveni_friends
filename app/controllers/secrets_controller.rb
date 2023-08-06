class SecretsController < ApplicationController
  before_action :authenticate_user!
  def index
    @recruits = Recruit.page(params[:page]).per(10)
  end
end
