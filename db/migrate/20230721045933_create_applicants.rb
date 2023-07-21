class CreateApplicants < ActiveRecord::Migration[6.1]
  def change
    create_table :applicants do |t|
      t.references :user,    null: false, foreign_key: true
      t.references :recruit, null: false, foreign_key: true
      t.timestamps
    end
    add_index :applicants, [:user_id, :recruit_id], unique: true
  end
end
