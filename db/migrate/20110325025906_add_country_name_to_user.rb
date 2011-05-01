class AddCountryNameToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :country_name, :string
    add_column :users, :send_quota_max, :integer
    add_column :users, :receive_quota_now, :integer
    add_index :users, :country_name, :name => 'by_country'
  end

  def self.down
    remove_column :users, :country_name
    remove_column :users, :send_quota_max
    remove_column :users, :receive_quota_now
  end
end
