class SecretsController < ApplicationController
  before_action :authenticate_user!
  def index
    @recruits = Recruit.all
  end
end
