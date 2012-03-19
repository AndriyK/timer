class CreateSources < ActiveRecord::Migration
  def self.up
    create_table :sources do |t|
      t.integer :user_id
      t.integer :work_id
      t.text :content

      t.timestamps
    end
    add_index :sources, :user_id
    add_index :sources, :work_id
  end

  def self.down
    drop_table :sources
  end
end
