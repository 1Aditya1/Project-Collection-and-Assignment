class AddSemyearToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :semester, :string
    add_column :projects, :year, :date
  end
end
