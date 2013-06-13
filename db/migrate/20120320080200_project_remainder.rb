class ProjectRemainder < ActiveRecord::Migration
  def self.up
    add_column :projects, :project_remainder, :string
  end

  def self.down
    remove_column :projects, :project_remainder, :string
  end
end
