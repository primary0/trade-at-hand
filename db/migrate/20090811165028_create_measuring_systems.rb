class CreateMeasuringSystems < ActiveRecord::Migration
  def self.up
    create_table :measuring_systems do |t|
      t.string :name
      t.text :description
      t.string :abbreviation
      t.timestamps
    end
  end

  def self.down
    drop_table :measuring_systems
  end
end
