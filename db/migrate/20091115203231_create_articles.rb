class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.integer :article_category_id
      t.string :title
      t.text :description
      t.boolean :published, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
