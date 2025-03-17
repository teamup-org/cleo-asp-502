# frozen_string_literal: true

class AddEmphasisIdToStudents < ActiveRecord::Migration[7.2]
  def up
    add_reference :students, :emphases, foreign_key: true
  end

  def down
  end
end
