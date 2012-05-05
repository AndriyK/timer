class CreateCategoriesRoutines < ActiveRecord::Migration
  def self.up
    create_table :categories_routines, :id=>false do |t|
      t.integer :routine_id
      t.integer :category_id
    end

    add_index :categories_routines, :routine_id
    add_index :categories_routines, :category_id
    add_index :categories_routines, [:routine_id, :category_id], :unique => true

  end

  def self.down
    drop_table :categories_routines
  end
end
