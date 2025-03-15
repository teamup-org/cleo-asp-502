class AddAcademicStandingAndPreferencesToStudents < ActiveRecord::Migration[7.2]
  def change
    add_column :students, :academic_standing, :string
    add_column :students, :preference_online, :boolean
  end
end
