class CreateIslandCategories < ActiveRecord::Migration
  def self.up
    create_table :island_categories do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :island_categories
  end
end
