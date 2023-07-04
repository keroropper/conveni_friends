class AddColumnToRecruit < ActiveRecord::Migration[6.1]
  def change
    add_column :recruits, :address, :string
    add_column :recruits, :latitude, :float
    add_column :recruits, :longitude, :float
  end
end
