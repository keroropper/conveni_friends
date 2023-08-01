class Evaluation < ApplicationRecord
  belongs_to :evaluator, class_name: 'User'
  belongs_to :evaluatee, class_name: 'User'

  validates :score, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :feedback, :recruit_id, presence: true

  after_commit :execute_after_evaluation_save, on: :create

  private

  def execute_after_evaluation_save
    evaluatee.update_score
    evaluator.delete_relation(evaluatee, recruit_id)
  end
end
