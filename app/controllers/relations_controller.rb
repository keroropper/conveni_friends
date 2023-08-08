class RelationsController < ApplicationController
  before_action :authenticate_user!
  before_action :current_user?, only: :index
  def index
    @relation_users = current_user.relation_users
    @room = nil
    target_user = params[:target]
    if target_user.present?
      @user = User.find(target_user)
      finder = TargetRecruitFinder.new(current_user, target_user)
      @target_recruit = finder.find_target_recruit
      @room = current_user.find_target_room(target_user)
      @messages = @room.chat_messages
      @message = ChatRoom.new
    end
  end

  def create
    recruit_id = params[:recruit_id]
    other_user = params[:user_id]
    recruit = Recruit.find(recruit_id)
    if current_user.follow(other_user, recruit_id)
      current_user.create_chat_room(other_user)
      Notification.create(receiver_id: other_user, sender_id: current_user.id, category: 'relation')
      recruit.update(deleted_at: Time.current)
      redirect_to user_relations_path(current_user)
    end
  end

  def destroy; end

  private

  def current_user?
    redirect_to root_path if current_user.id != params[:user_id].to_i
  end
end
