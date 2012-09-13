class CreateListings < ActiveRecord::Migration
  def self.up
    create_table :listings do |t|
      t.integer :user_id
      t.integer :product_id
      t.text :description
      t.integer :listing_type_id
      t.date :expiry_date
      t.integer :quantity
      t.integer :measuring_system
      t.float :price
      t.boolean :sold, :default => false, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :listings
  end
end
