class RelationsController < ApplicationController
  before_action :authenticate_user!
  def index
    @relation_users = current_user.user_relations
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
    if current_user.follow(other_user, recruit_id)
      current_user.create_chat_room(other_user)
      redirect_to user_relations_path(current_user)
    end
  end

  def destroy
  end
end
