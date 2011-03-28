class CreateAssigns < ActiveRecord::Migration
  def self.up
    create_table :assigns do |t|
      t.integer :sender_id, :receiver_id
      t.datetime :sent_at
      t.integer :waiting_days, :default => 7
      t.timestamps
    end

    add_index :assigns, :sender_id
    add_index :assigns, :receiver_id
  end

  def self.down
    drop_table :assigns
  end
end
