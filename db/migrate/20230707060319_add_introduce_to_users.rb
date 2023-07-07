class AddIntroduceToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :introduce, :text
  end
end
