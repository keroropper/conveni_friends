class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.string :text, null: false, default: ""
      t.references :user
      t.references :recruit
      t.timestamps
    end
  end
end
