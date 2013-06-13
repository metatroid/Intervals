class AddFeeToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :projectfee, :string
  end

  def self.down
    remove_column :projects, :projectfee, :string
  end
end
