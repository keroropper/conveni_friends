class ModifyRecruitsColumn < ActiveRecord::Migration[6.1]
  def change
    execute 'ALTER TABLE recruits MODIFY latitude FLOAT(9, 6);'
    execute 'ALTER TABLE recruits MODIFY longitude FLOAT(9, 6);'
  end
end
