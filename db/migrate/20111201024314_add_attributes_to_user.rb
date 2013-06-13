class AddAttributesToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :admin, :boolean, :default => false
    add_column :users, :name, :string
    add_column :users, :phone, :string
    add_column :users, :address1, :string
    add_column :users, :address2, :string
    add_column :users, :timezone, :string
  end

  def self.down
    remove_column :users, :admin
    remove_column :users, :name
    remove_column :users, :phone
    remove_column :users, :address1
    remove_column :users, :address2
    remove_column :users, :timezone
  end
end
