class ApplicantsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :recruit_params, only: [:create, :destroy]

  def create
    @applicant = Applicant.create(user_id: current_user.id, recruit_id: @recruit.id)
    redirect_to @recruit if current_user == @recruit.user
    if @applicant
      respond_to do |format|
        format.html { redirect_to @recruit }
        format.js
      end
    end
  end

  def destroy
    applicant = Applicant.find_by(user_id: current_user.id, recruit_id: @recruit.id)
    if applicant.destroy
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
