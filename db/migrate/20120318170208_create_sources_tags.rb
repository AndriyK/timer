class CreateSourcesTags < ActiveRecord::Migration
  def self.up
    create_table :sources_tags, :id=>false do |t|
      t.integer :source_id
      t.integer :tag_id
    end
    add_index :sources_tags, [:source_id, :tag_id], :unique => true
  end

  def self.down
    drop_table :sources_tags
  end
end
