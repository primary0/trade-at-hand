class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string :msisdn
      t.text :message
      t.boolean :is_valid, :default => false
      t.string :sms_command
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
