class CreateEvaluations < ActiveRecord::Migration[6.1]
  def change
    create_table :evaluations do |t|
      t.references :evaluator, foreign_key: { to_table: :users }, null: false
      t.references :evaluatee, foreign_key: { to_table: :users }, null: false
      t.integer :score, null: false
      t.string :feedback, null: false, default: ''
      t.integer :recruit_id, null: false
      t.timestamps
    end
  end
end
