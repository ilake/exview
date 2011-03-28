class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.integer :sender_id, :recipient_id
      t.boolean :sender_deleted, :recipient_deleted, :default => 0
      t.string :subject
      t.text :body
      t.datetime :read_at
      t.timestamps
    end

    add_index :messages, :sender_id
    add_index :messages, :recipient_id
  end

  def self.down
    drop_table messages
  end
end
