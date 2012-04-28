class CreateRoutines < ActiveRecord::Migration
  def self.up
    create_table :routines do |t|
      t.integer :work_id
      t.integer :user_id
      t.string :days
      t.string :weeks
      t.string :dates

      t.timestamps
    end
    add_index :routines, :user_id
    add_index :routines, :work_id
  end

  def self.down
    drop_table :routines
  end
end
