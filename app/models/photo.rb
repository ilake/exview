# == Schema Information
# Schema version: 20110323064406
#
# Table name: photos
#
#  id                  :integer(4)      not null, primary key
#  sender_id           :integer(4)
#  receiver_id         :integer(4)
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer(4)
#  avatar_updated_at   :datetime
#  memo                :text
#  created_at          :datetime
#  updated_at          :datetime
#

class Photo < ActiveRecord::Base
  acts_as_commentable

  belongs_to :sender, :class_name => 'User', :foreign_key => 'sender_id'
  belongs_to :receiver, :class_name => 'User', :foreign_key => 'receiver_id'

  scope :include_sender, :include => :sender
  scope :include_receiver, :include => :receiver
  scope :uniq_receiver_ids, select("DISTINCT receiver_id")

  validates :memo, :presence => true, :length => { :within => 1..10000000 }

  has_attached_file :avatar, :styles => { :medium => "100x>100" }
end
