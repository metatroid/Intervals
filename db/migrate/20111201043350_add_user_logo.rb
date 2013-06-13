class AddUserLogo < ActiveRecord::Migration
  def self.up
    add_column :users, :userlogo, :string
  end

  def self.down
    remove_column :users, :userlogo
  end
end
