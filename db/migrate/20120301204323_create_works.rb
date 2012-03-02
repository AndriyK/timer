class CreateWorks < ActiveRecord::Migration
  def self.up
    create_table :works do |t|
      t.date :date
      t.string :time
      t.integer :duration
      t.string :description
      t.integer :user_id

      t.timestamps
    end
    add_index :works, :user_id
    add_index :works, :created_at
  end

  def self.down
    drop_table :works
  end
end
