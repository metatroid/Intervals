class ProjectBalance < ActiveRecord::Migration
  def self.up
    add_column :projects, :projectbalance, :string
  end

  def self.down
    remove_column :projects, :projectbalance, :string
  end
end
