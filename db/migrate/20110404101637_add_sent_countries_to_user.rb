class AddSentCountriesToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :sent_countries, :text, :default => ""
  end

  def self.down
    remove_column :users, :sent_countries
  end
end
