class AddSchedules < ActiveRecord::Migration[7.2]
  def up
    if table_exists?(:schedules)
      drop_table :schedules
    end
    create_table :schedules do |t|
      t.integer :semester  
      t.references :class_attribute, null: false, foreign_key: true
      t.string :student_google_id, null: false
      t.timestamps
    end
    add_foreign_key :schedules, :students, column: :student_google_id, primary_key: :google_id

  end
  def down
    if table_exists?(:schedules)
      drop_table :schedules
    end
  end
end
