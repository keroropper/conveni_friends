class SecretsController < ApplicationController
  def index
    @recruits = Recruit.all
    @recruit = Recruit.first
  end
end
