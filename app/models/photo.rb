# == Schema Information
# Schema version: 20110328031404
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
#  comments_count      :integer(4)      default(0)
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

  after_create :deliver_notification

  private
  def deliver_notification
    Notifier.delay.photo_notification(self, self.sender, self.receiver)
  end
end
