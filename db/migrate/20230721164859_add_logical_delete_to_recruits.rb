class AddLogicalDeleteToRecruits < ActiveRecord::Migration[6.1]
  def change
    add_column :recruits, :deleted_at, :datetime
  end
end
