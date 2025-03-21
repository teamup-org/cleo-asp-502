# frozen_string_literal: true

class CreateTracks < ActiveRecord::Migration[7.2]
  def up
    create_table :tracks, id: false do |t|
      t.integer :course_id, null: false
      t.string :tname, limit: 255, null: false

      t.timestamps
    end
    add_index :tracks, %i[course_id tname], unique: true
    add_foreign_key :tracks, :courses, column: :course_id
  end
  def down
    if table_exists?(:tracks)
    drop_table :tracks
    end
  end
end
