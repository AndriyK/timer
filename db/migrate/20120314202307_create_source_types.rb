class CreateSourceTypes < ActiveRecord::Migration
  def self.up
    create_table :source_types do |t|
      t.string  :name
      t.integer :user_id

      t.timestamps
    end
    add_index :source_types, :user_id
  end

  def self.down
    drop_table :source_types
  end
end
