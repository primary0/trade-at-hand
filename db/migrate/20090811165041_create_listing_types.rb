class CreateListingTypes < ActiveRecord::Migration
  def self.up
    create_table :listing_types do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :listing_types
  end
end
