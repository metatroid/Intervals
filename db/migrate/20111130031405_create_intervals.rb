class CreateIntervals < ActiveRecord::Migration
  def self.up
    create_table :intervals do |t|
      t.integer :project_id
      t.string :start
      t.string :end
      t.string :total
      t.string :description
      t.timestamps
    end
  end

  def self.down
    drop_table :intervals
  end
end
