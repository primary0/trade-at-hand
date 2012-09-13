class CreateIslands < ActiveRecord::Migration
  def self.up
    create_table :islands do |t|
      t.string :name
      t.integer :atoll_id
      t.integer :island_category_id
      t.string :description
      t.timestamps
    end
  end

  def self.down
    drop_table :islands
  end
end