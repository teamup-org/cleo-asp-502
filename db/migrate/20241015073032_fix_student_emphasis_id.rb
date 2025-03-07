class FixStudentEmphasisId < ActiveRecord::Migration[7.2]
  def up
    unless column_exists?(:students, :emphasis_id)
        rename_column :students, :emphases_id, :emphasis_id
    end
  end
  def down
  end
end