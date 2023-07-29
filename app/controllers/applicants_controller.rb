class ApplicantsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :recruit_params, only: [:recruit_applicants_index, :create, :destroy]
  before_action :my_recruit?, only: :recruit_applicants_index
  before_action :applicant_user?, only: :user_applicants_index

  def user_applicants_index
    @recruits = current_user.applicant_recruits
  end

  def recruit_applicants_index
    @users = @recruit.applicant_users
  end

  def create
    @applicant = Applicant.new(user_id: current_user.id, recruit_id: @recruit.id)
    redirect_to @recruit if current_user == @recruit.user
    if @applicant.save
      Notification.create(sender_id: current_user.id, receiver_id: @recruit.user.id, category: 'applicant', recruit_id: @recruit.id)
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

  def applicant_user?
    user = User.find(params[:user_id])
    redirect_to root_path if current_user != user
  end

  def my_recruit?
    redirect_to root_path if @recruit.user != current_user
  end

  def recruit_params
    @recruit = Recruit.find(params[:recruit_id])
  end
end
