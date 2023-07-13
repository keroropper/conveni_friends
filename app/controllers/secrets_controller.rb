class SecretsController < ApplicationController
  def index
    @recruits = Recruit.all
  end
end
