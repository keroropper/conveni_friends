class RecruitsController < ApplicationController
  before_action :authenticate_user!
  before_action :params_of_recruit, only: [:index, :show, :edit, :update]
  before_action :params_of_tags, only: [:create, :update]
  before_action :image_count, only: [:new, :create, :edit, :update]
  def show
    recruit_tags = RecruitTag.where(recruit_id: @recruit.id)
    @tags = recruit_tags.map { |recruit_tag| Tag.find(recruit_tag.tag_id) }
    @comments = @recruit.comments
    @comment = current_user.comments.new
    @applicant = Applicant.find_by(user_id: current_user.id, recruit_id: @recruit.id)
  end

  def new
    @image_count = 0
    @recruit = Recruit.new(tags: [Tag.new])
  end

  def edit
    tags_name = @recruit.tags.map(&:name)
    @tags = tags_name.join(' ')
  end

  def create
    @recruit = current_user.recruits.build(recruit_params)
    if @recruit.save && @recruit.recruit_tags_create(@tags)
      redirect_to root_path
    else
      render action: :new
    end
  end

  def update
    @image_count = @recruit.images.count
    delete_num = params[:recruit][:image_num].split(',')
    image_params = params[:recruit][:images]
    if @recruit.update(recruit_params) && @recruit.recruit_tags_create(@tags) && @recruit.image_remain?(delete_num, image_params)
      @recruit.image_delete(delete_num) if delete_num
      redirect_to root_url
    else
      @recruit.errors.add(:images, '画像を選択してください') unless @recruit.image_remain?(delete_num, image_params)
      render 'edit'
    end
  end

  def search
    @recruits = Recruit.includes(:user).page(params[:page]).per(10)
    keyword = params[:keyword]
    address = params[:address]
    tags = params[:name]
    date = Date.parse(params[:date]).strftime('%Y-%m-%d') if params[:date].present?
    meeting_time = params[:meeting_time]
    required_time = params[:required_time]
    start_age = params[:start_age]
    end_age = params[:end_age]
    score = params[:score]
    @recruits = @recruits.with_user(keyword)
      .with_address(address)
      .with_tags(tags)
      .with_date(date)
      .with_meeting_time(meeting_time)
      .with_required_time(required_time)
      .with_age_range(start_age, end_age)
      .with_score(score)
  end

  private

  def image_count
    @image_count = if ['update', 'edit'].include?(action_name)
                     @recruit.images.count
                   else
                     0
                   end
  end

  def calculate_square_size(image)
    metadata = image.blob.metadata
    [metadata[:width], metadata[:height]].min
  end

  def params_of_recruit
    @recruit = Recruit.find(params[:id])
  end

  def params_of_tags
    @tags = params[:recruit][:tags_attributes]["0"][:name]
  end

  def recruit_params
    params.require(:recruit).permit(:title, :explain, :date, :required_time, :meeting_time,
                                    :address, :latitude, :longitude, images: [], tags_attributes: [:name])
  end
end
