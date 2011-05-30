class CreateUserLangMappings < ActiveRecord::Migration
  def self.up
    create_table :user_lang_mappings do |t|
      t.belongs_to :user
      t.integer :native_id, :practice_id
    end

    add_index :user_lang_mappings, [:native_id, :practice_id]
  end

  def self.down
    drop_table :user_lang_mappings
  end
end
