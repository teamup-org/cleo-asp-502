class AddClassAttributes < ActiveRecord::Migration[7.2]
  def up
    create_table :class_attributes do |t|
      t.integer :crn
      t.string :class_type
      t.string :is_online
      t.string :instructor
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
  def down
    drop_table :class_attributes
  end

end
