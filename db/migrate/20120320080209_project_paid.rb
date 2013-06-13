class ProjectPaid < ActiveRecord::Migration
  def self.up
    add_column :projects, :project_paid, :string
  end

  def self.down
    remove_column :projects, :project_paid, :string
  end
end
