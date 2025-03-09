# frozen_string_literal: true

class ChangeGoogleIdToStringInStudents < ActiveRecord::Migration[7.2]
  def up
    change_column :students, :google_id, :string
  end
  def down
  end
end
