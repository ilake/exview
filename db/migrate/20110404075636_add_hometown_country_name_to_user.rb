# -*- encoding : utf-8 -*-
class AddHometownCountryNameToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :hometown_country_name, :string
    add_index :users, :hometown_country_name, :name => 'by_hometown'
  end

  def self.down
    remove_column :users, :hometown_country_name
  end
end
