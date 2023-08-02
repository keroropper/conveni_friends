class AddScoreToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :score, :float, scale: 2 ,null: false, default: 0
    add_column :users, :score_count, :integer, null: false, default: 0
  end
end
