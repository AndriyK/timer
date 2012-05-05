class CreateRoutines < ActiveRecord::Migration
  def self.up
    create_table :routines do |t|
      t.integer :user_id
      t.string :from
      t.string :to
      t.string :description
      t.string :days
      t.string :weeks
      t.string :dates
      t.timestamps
    end
    add_index :routines, :user_id
  end

  def self.down
    drop_table :routines
  end
end
