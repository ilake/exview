# -*- encoding : utf-8 -*-
class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.integer :sender_id, :receiver_id
      t.string :avatar_file_name, :avatar_content_type
      t.integer :avatar_file_size
      t.datetime :avatar_updated_at
      t.text :memo
      t.string :from_country_name, :to_country_name
      t.string :cached_slug
      t.timestamps
    end

    add_index :photos, :sender_id
    add_index :photos, :receiver_id
    add_index :photos, :avatar_content_type
  end

  def self.down
    drop_table :photos
  end
end
