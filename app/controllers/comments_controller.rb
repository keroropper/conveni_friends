class CommentsController < ApplicationController
  def create
    @recruit = Recruit.find(params[:comment][:recruit_id])
    @comments = @recruit.comments
    @comment = current_user.comments.new(comment_params)
    if @comment.save
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
