class MakeScheduleHaveUniqueCourses < ActiveRecord::Migration[7.2]
  def change
    if table_exists?(:schedule_classes)
      drop_table :schedule_classes
    end  
    create_table :schedule_classes do |t|
      t.integer :semester, null: false
      t.string :student_google_id, null: false
      t.references :class_attribute, null: false, foreign_key: true
      t.timestamps
      
      # Index for foreign key constraint to schedules
      t.index [:semester, :student_google_id], name: 'idx_schedule_classes_on_schedule'
      
      # Ensure a class can only be added once to a schedule
      t.index [:semester, :student_google_id, :class_attribute_id], unique: true, name: 'idx_unique_class_in_schedule'
    end
    
    # Add a unique index to ensure course_id is unique within each schedule
    add_index :schedule_classes, [:semester, :student_google_id, :class_attribute_id], unique: true, name: 'idx_unique_course_in_schedule'    
  end
end
