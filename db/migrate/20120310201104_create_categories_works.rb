class CreateCategoriesWorks < ActiveRecord::Migration
  def self.up
    create_table :categories_works, :id=>false do |t|
      t.integer :work_id
      t.integer :category_id
    end

    add_index :categories_works, :work_id
    add_index :categories_works, :category_id
    add_index :categories_works, [:work_id, :category_id], :unique => true

  end

  def self.down
    drop_table :categories_works
  end
end
