class CreateWorks < ActiveRecord::Migration
  def self.up
    create_table :works do |t|
      t.datetime :from
      t.datetime :to
      t.integer :duration
      t.string :description
      t.integer :user_id

      t.timestamps
    end
    add_index :works, :user_id
    add_index :works, :from
  end

  def self.down
    drop_table :works
  end
end
