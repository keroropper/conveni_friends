class CreateRelations < ActiveRecord::Migration[6.1]
  def change
    create_table :relations do |t|
      t.integer :follower_id
      t.integer :followed_id
      t.references :recruit, null: false,  foreign_key: true, default: 0
      t.timestamps
    end
    add_index :relations, [:follower_id, :followed_id], unique: true
  end
end
