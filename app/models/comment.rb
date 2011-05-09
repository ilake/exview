# -*- encoding : utf-8 -*-
# == Schema Information
# Schema version: 20110327030838
#
# Table name: comments
#
#  id               :integer(4)      not null, primary key
#  title            :string(50)      default("")
#  comment          :text
#  commentable_id   :integer(4)
#  commentable_type :string(255)
#  user_id          :integer(4)
#  created_at       :datetime
#  updated_at       :datetime
#

class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true, :counter_cache => true

  default_scope :order => 'created_at DESC'

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user

  validates :comment, :presence => true

  after_create :deliver_notification

  def mail_receiver
    #下過comment的
    commenter_ids = Comment.find(:all, :conditions => {:commentable_id => self.commentable_id, :commentable_type => self.commentable_type}).map{|c| c.user_id}
    #加入這筆comment 所要談論object 的擁有者
    commenter_ids << self.commentable.sender_id
    commenter_ids.uniq!
    #扣掉本筆comment的擁有者
    commenter_ids.delete(self.user_id)

    users = User.find(:all, :conditions => {:id => commenter_ids})
  end

  private
  def deliver_notification
    self.mail_receiver.each do |u|
      Notifier.delay.comment_notification(u, self)
    end
  end
end
