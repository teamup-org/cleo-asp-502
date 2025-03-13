# frozen_string_literal: true

class CreatePrerequisites < ActiveRecord::Migration[7.2]
  def up
    create_table :prerequisites, id: false, primary_key: :course_id do |t|
      t.integer :course_id
      t.integer :prereq_id

      t.timestamps
    end

    add_index :prerequisites, :course_id
    add_index :prerequisites, :prereq_id

    add_index :prerequisites, %i[course_id prereq_id], unique: true
  end
  def down
    if table_exists?(:prerequisites)
    drop_table :prerequisites
    end
  end
end
