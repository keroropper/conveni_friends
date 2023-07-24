class RelationsController < ApplicationController

  def index
    @relation_users = (current_user.followings + current_user.followers).sort_by { |user| user.created_at }.reverse
    target_relation = Relation.where("(follower_id = ? AND followed_id = ?) OR (follower_id = ? AND followed_id = ?)", current_user.id, params[:target], params[:target], current_user.id)
    if target_relation.present?
      @target_recruit = Recruit.find(target_relation.first.recruit_id)
    else
      @target_recruit = nil
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    recruit_id = params[:recruit_id]
    follow = current_user.active_relations.build(follower_id: params[:user_id], recruit_id: recruit_id)
    follow.save
    redirect_to user_relations_path(current_user)
  end

  def destroy
  end
end
