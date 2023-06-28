class AddColumnNameToRecruit < ActiveRecord::Migration[6.1]
  def change
    add_column :recruits, :title, :string, null: false, default: ''
    add_column :recruits, :explain, :string, null: false, default: ''
    add_column :recruits, :date, :date, null: false, default: Date.today
  end
end
