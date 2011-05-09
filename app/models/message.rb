# -*- encoding : utf-8 -*-
# == Schema Information
# Schema version: 20110328031404
#
# Table name: messages
#
#  id                :integer(4)      not null, primary key
#  sender_id         :integer(4)
#  recipient_id      :integer(4)
#  sender_deleted    :boolean(1)
#  recipient_deleted :boolean(1)
#  subject           :string(255)
#  body              :text
#  read_at           :datetime
#  created_at        :datetime
#  updated_at        :datetime
#

class Message < ActiveRecord::Base
  validates_presence_of :subject, :body, :sender_id, :recipient_id

  is_private_message

  # The :to accessor is used by the scaffolding,
  # uncomment it if using it or you can remove it if not
  attr_accessor :to

  after_create :deliver_notification

  private
  def deliver_notification
    Notifier.delay.message_notification(self, self.sender, self.recipient)
  end
end
