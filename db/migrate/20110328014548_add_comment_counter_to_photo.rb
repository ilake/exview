# -*- encoding : utf-8 -*-
class AddCommentCounterToPhoto < ActiveRecord::Migration
  def self.up
    add_column :photos, :comments_count, :integer, :default => 0
    Photo.reset_column_information
    Photo.find(:all).each do |p|
      Photo.update_counters p.id, :comments_count => p.comments.length
    end
  end

  def self.down
    remove_column :photos, :comments_count
  end
end
