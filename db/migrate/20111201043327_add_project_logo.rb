class AddProjectLogo < ActiveRecord::Migration
  def self.up
    add_column :projects, :projectlogo, :string
  end

  def self.down
    remove_column :projects, :projectlogo
  end
end
