class AddMeasuringSystemIdToListing < ActiveRecord::Migration
  def self.up
    add_column :listings, :measuring_system_id, :integer
  end

  def self.down
    remove_column :listings, :measuring_system_id
  end
end
