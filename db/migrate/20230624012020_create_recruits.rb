class CreateRecruits < ActiveRecord::Migration[6.1]
  def change
    create_table :recruits do |t|
      t.integer :required_time, null: false, default: 0
      t.time :meeting_time, null: false, default: 0
      t.string :option
      t.boolean :closed, default: false
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
