class RecruitsController < ApplicationController
  before_action :authenticate_user!
  def new
    @recruit = Recruit.new(tags: [Tag.new])
  end

  def create
    @recruit = current_user.recruits.build(recruit_params)
    @tags = params[:recruit][:tags_attributes]["0"][:name]

    if @recruit.save && @recruit.recruit_tags_create(@tags)
      redirect_to root_path
    else
      render 'new'
    end
  end

  private

  def recruit_params
    params.require(:recruit).permit(:title, :explain, :date, :required_time, :meeting_time, :option, 
                                    :address, :latitude, :longitude, images: [], tags_attributes: [:name])
  end
end
