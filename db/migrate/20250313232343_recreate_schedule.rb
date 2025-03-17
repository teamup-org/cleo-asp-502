class RecreateSchedule < ActiveRecord::Migration[7.2]
  def change
        # Create a schedules table to represent a student's schedule for a semester
    if table_exists?(:schedules)
      drop_table :schedules
    end  
    create_table :schedules, id: false, primary_key: %i[semester student_google_id] do |t|
      t.integer :semester
      t.string :student_google_id, null: false
      t.timestamps
    end
    add_foreign_key :schedules, :students, column: :student_google_id, primary_key: :google_id

    # Create a join table to connect schedules with classes
    create_table :schedule_classes do |t|
      t.integer :semester, null: false
      t.string :student_google_id, null: false
      t.references :class_attribute, null: false, foreign_key: true
      t.timestamps
      
      # Create a composite foreign key to the schedules table
      t.index [:semester, :student_google_id], name: 'idx_schedule_classes_on_schedule'
      # Ensure a class can only be added once to a schedule
      t.index [:semester, :student_google_id, :class_attribute_id], unique: true, name: 'idx_unique_class_in_schedule'
    end
  end
end
