class AddMessageTypeToMessage < ActiveRecord::Migration
  def self.up
    add_column :messages, :message_type, :integer, :default => "0", :null => false
  end

  def self.down
    remove_column :messages, :message_type
  end
end
