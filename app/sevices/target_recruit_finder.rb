class TargetRecruitFinder
  def initialize(current_user, target_user_id)
    @current_user = current_user
    @target_user_id = target_user_id
  end

  def find_target_recruit
    target_relation = Relation.where("(follower_id = ? AND followed_id = ?) OR (follower_id = ? AND followed_id = ?)",
                                     @current_user.id, @target_user_id, @target_user_id, @current_user.id)
    target_relation.present? ? Recruit.find(target_relation.first.recruit_id) : nil
  end
end
