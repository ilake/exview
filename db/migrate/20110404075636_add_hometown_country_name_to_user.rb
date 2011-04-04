class AddHometownCountryNameToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :hometown_country_name, :string
  end

  def self.down
    remove_column :users, :hometown_country_name
  end
end
