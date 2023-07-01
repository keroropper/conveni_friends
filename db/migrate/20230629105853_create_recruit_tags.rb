class CreateRecruitTags < ActiveRecord::Migration[6.1]
  def change
    create_table :recruit_tags do |t|
      t.integer :recruit_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
