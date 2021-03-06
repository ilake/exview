# -*- encoding : utf-8 -*-
# == Schema Information
# Schema version: 20110327030838
#
# Table name: assigns
#
#  id           :integer(4)      not null, primary key
#  sender_id    :integer(4)
#  receiver_id  :integer(4)
#  sent_at      :datetime
#  waiting_days :integer(4)      default(7)
#  created_at   :datetime
#  updated_at   :datetime
#

class Assign < ActiveRecord::Base
  belongs_to :sender, :class_name => 'User', :foreign_key => 'sender_id'
  belongs_to :receiver, :class_name => 'User', :foreign_key => 'receiver_id'

  default_scope :order => "created_at DESC"

  scope :unexpired, where("waiting_days > 0")
  scope :unsent, where("sent_at is NULL")
  scope :uniq_receiver_ids, select("DISTINCT receiver_id")

  before_create :init_waiting_days
  private
  def init_waiting_days
    self.waiting_days = APP_CONFIG["waiting_days"]
  end
end
