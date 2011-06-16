class AddLangListToUsersTable < ActiveRecord::Migration
  def self.up
    add_column :users, :practice_languages_list, :string
    add_column :users, :native_languages_list, :string
  end

  def self.down
    remove_column :users, :practice_languages_list
    remove_column :users, :native_languages_list
  end
end
