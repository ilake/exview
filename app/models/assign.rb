# == Schema Information
# Schema version: 20110325094557
#
# Table name: assigns
#
#  id          :integer(4)      not null, primary key
#  sender_id   :integer(4)
#  receiver_id :integer(4)
#  expire_at   :datetime
#  sent_at     :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

class Assign < ActiveRecord::Base
  belongs_to :sender, :class_name => 'User', :foreign_key => 'sender_id'
  belongs_to :receiver, :class_name => 'User', :foreign_key => 'receiver_id'

  scope :unexpired, where("waiting_days > 0")
  scope :unsent, where("sent_at is NULL")
  scope :uniq_receiver_ids, select("DISTINCT receiver_id")

end
