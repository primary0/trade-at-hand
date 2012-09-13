class CreateAtolls < ActiveRecord::Migration
  def self.up
    create_table :atolls do |t|
      t.string :name
      t.string :abbreviation
      t.integer :province_id
      t.timestamps
    end
  end

  def self.down
    drop_table :atolls
  end
end
