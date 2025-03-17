# frozen_string_literal: true

class CreateMajors < ActiveRecord::Migration[7.2]
  def up
    create_table :majors do |t|
      t.string :mname, limit: 255
      t.string :cname, limit: 255

      t.timestamps
    end

    # enforces uniqueness of composite (mname, cname)
    add_index :majors, %i[mname cname], unique: true
  end
  def down
    if table_exists?(:majors)
    drop_table :majors
    end
  end
end
