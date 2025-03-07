# frozen_string_literal: true

class RenameEmphasesIdToEmphasisId < ActiveRecord::Migration[7.2]
  def up
    rename_column :students, :emphases_id, :emphasis_id
  end
  def down
  end
end
