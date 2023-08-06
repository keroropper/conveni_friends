class EvaluationsController < ApplicationController
  before_action :authenticate_user!

  def incomplete_index; end

  def index
    @evaluations = current_user.evaluations.page(params[:page]).per(20)
  end

  def new
    @user = User.find(params[:user_id])
    @evaluation = @user.evaluations.new
    finder = TargetRecruitFinder.new(current_user, @user.id)
    @target_recruit = finder.find_target_recruit.id
  end

  def create
    @user = User.find(params[:user_id])
    @evaluation = @user.evaluations.build(evaluation_params)
    if @evaluation.save
      redirect_to root_path
    else
      render action: :new, score: params[:evaluation][:score]
    end
  end

  private

  def evaluation_params
    params.require(:evaluation).permit(:feedback, :evaluator_id, :score, :recruit_id)
  end
end
