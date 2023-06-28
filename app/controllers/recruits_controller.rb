class RecruitsController < ApplicationController
  before_action :authenticate_user!
  def new
    @recruit = Recruit.new
  end

  def edit; end

  def create
    @recruit = current_user.recruits.build(recruit_params)
    if @recruit.save
      redirect_to root_path
    else
      render 'new'
    end
  end

  def update; end

  private

  def recruit_params
    params.require(:recruit).permit(:title, :explain, :date, :required_time, :meeting_time, :option, images: [])
  end
end
