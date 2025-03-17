class AddClassMeetingAttributes < ActiveRecord::Migration[7.2]
    def up
        create_table :class_meeting_attributes do |t|
            t.boolean :sunday
            t.boolean :monday
            t.boolean :tuesday
            t.boolean :wednesday
            t.boolean :thursday
            t.boolean :friday
            t.boolean :saturday
            t.time :start_time
            t.time :end_time
            t.date :start_date
            t.date :end_date
            t.string :location
            t.string :meeting_type
            t.references :class_attribute, null: false, foreign_key: true

            t.timestamps
        end
    end
    def down
      drop_table :class_meeting_attributes
    end
  
  end