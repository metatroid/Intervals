class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.integer :user_id
      t.string :name
      t.string :client_name
      t.string :client_email
      t.text :description
      t.string :pro_url
      t.string :dev_url
      t.string :total_time
      t.string :rate, :default => "0"
      t.boolean :completed, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
