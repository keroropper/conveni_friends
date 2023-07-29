class CommentsController < ApplicationController
  before_action :authenticate_user!
  def create
    @recruit = Recruit.find(params[:comment][:recruit_id])
    @comments = @recruit.comments
    @comment = current_user.comments.new(comment_params)
    if @comment.save
      Notification.create(sender_id: current_user.id, receiver_id: @recruit.user.id, category: 'comment', recruit_id: @recruit.id) if current_user != @recruit.user
      respond_to do |format|
        format.html { redirect_to @recruit }
        format.js
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:text, :recruit_id)
  end
end
