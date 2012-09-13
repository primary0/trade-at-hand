class MeasuringSystemsProducts < ActiveRecord::Migration
  def self.up
    create_table :measuring_systems_products, :id => false do |t|
      t.integer :measuring_system_id
      t.integer :product_id
    end
  end

  def self.down
    drop_table :measuring_systems_products
  end
end
