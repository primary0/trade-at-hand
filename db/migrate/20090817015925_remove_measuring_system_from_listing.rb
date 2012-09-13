class RemoveMeasuringSystemFromListing < ActiveRecord::Migration
  def self.up
    remove_column :listings, :measuring_system
  end

  def self.down
    add_column :listings, :measuring_system, :integer
  end
end
