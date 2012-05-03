class ActsAsTaggedTreeMigration < ActiveRecord::Migration
  def self.up
    create_table :tag_trees do |t|
      t.integer :parent_id
      t.integer :tag_id
      t.integer :node_id
      t.string  :name
      t.string  :klass

      t.timestamps
    end
    TagTree.create(:id =>0, :name => "root")
  end

  def self.down
    drop_table :tag_trees
  end
end
