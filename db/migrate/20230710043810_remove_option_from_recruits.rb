class RemoveOptionFromRecruits < ActiveRecord::Migration[6.1]
  def change
    remove_column :recruits, :option, :string
  end
end
