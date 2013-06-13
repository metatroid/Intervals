class ProjectAmount < ActiveRecord::Migration
  def self.up
    add_column :projects, :project_amount, :string
  end

  def self.down
    remove_column :projects, :project_amount, :string
  end
end
