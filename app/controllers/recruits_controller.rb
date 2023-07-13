class RecruitsController < ApplicationController
  before_action :authenticate_user!
  def show
    @recruit = Recruit.find(params[:id])
    recruit_tags = RecruitTag.where(recruit_id: @recruit.id)
    @tags = recruit_tags.map { |recruit_tag| Tag.find(recruit_tag.tag_id) }
  end

  def new
    @recruit = Recruit.new(tags: [Tag.new])
  end

  def edit; end

  def create
    @recruit = current_user.recruits.build(recruit_params)
    @tags = params[:recruit][:tags_attributes]["0"][:name]
    if @recruit.save && @recruit.recruit_tags_create(@tags)
      redirect_to root_path
    else
      render 'new'
    end
  end

  def update; end

  private

  def calculate_square_size(image)
    metadata = image.blob.metadata
    [metadata[:width], metadata[:height]].min
  end

  def recruit_params
    params.require(:recruit).permit(:title, :explain, :date, :required_time, :meeting_time,
                                    :address, :latitude, :longitude, images: [], tags_attributes: [:name])
  end
end
