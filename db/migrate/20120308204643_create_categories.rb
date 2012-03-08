class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.integer :pcategory
      t.string :scope
      t.integer :user_id

      t.timestamps
    end
    add_index :categories, :user_id
  end

  def self.down
    drop_table :categories
  end
end
