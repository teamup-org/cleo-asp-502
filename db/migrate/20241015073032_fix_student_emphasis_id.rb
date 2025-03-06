class FixStudentEmphasisId < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:students, :emphases_id)
      Student.rename_column :students, :emphases_id, :emphasis_id
    end
  end
end