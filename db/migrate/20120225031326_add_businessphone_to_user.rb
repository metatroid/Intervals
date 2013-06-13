class AddBusinessphoneToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :businessphone, :string
  end

  def self.down
    remove_column :users, :businessphone
  end

end
