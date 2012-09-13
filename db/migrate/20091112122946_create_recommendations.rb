class CreateRecommendations < ActiveRecord::Migration
  def self.up
    create_table :recommendations do |t|
      t.integer :user_id
      t.integer :author_id
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :recommendations
  end
end
