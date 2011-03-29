# == Schema Information
# Schema version: 20110327030838
#
# Table name: users
#
#  id                  :integer(4)      not null, primary key
#  login               :string(255)     not null
#  email               :string(255)     not null
#  gender              :string(255)
#  speak               :string(255)
#  memo                :text
#  crypted_password    :string(255)     not null
#  password_salt       :string(255)     not null
#  persistence_token   :string(255)     not null
#  single_access_token :string(255)     not null
#  perishable_token    :string(255)     not null
#  login_count         :integer(4)      default(0), not null
#  failed_login_count  :integer(4)      default(0), not null
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  country_name        :string(255)
#  send_quota_max      :integer(4)
#  receive_quota_now   :integer(4)
#

class User < ActiveRecord::Base
  acts_as_authentic
  has_private_messages

  scope :diff_country, lambda {|country| where("country_name not in (?)", country)}
  scope :same_country, lambda {|country| where("country_name = ?", country)}
  scope :have_quota, where("receive_quota_now > 0")
  scope :not_assigned_or_sent_or_self, lambda{|assigned_sent_ids| where("id not in (?)", assigned_sent_ids)}

  has_many :sent_photos, :class_name => 'Photo', :foreign_key => 'sender_id'
  has_many :receive_photos, :class_name => 'Photo', :foreign_key => 'receiver_id'
  has_many :assigns, :class_name => 'Assign', :foreign_key => 'sender_id'
  has_many :assigned_receivers, :through => :assigns, :source => :receiver
  has_many :comments

  before_create :init_user_quota

  def to_param
    "#{id}-#{login}"
  end

  def name
    login
  end

  #Find friend policy
  #(1)receiver have be assigned to sender could not be assigned again
  #(2)receiver have be assigned to another one, even not active, could not assigned, either
  #(3)[NOTICE] receiver if just ever receive the photos by sender,but dont be assigned ever, dont assigns, either 
  #Dont use the role(3) right now, when startup, not too many users
  def find_one_friend
    # if the amount of users be assigned smaller than send quota
    if self.assigns.unsent.unexpired.count < self.send_quota_max
      #receiver have be assigned to sender could not assigned again
      assigned_ids = self.assigns.uniq_receiver_ids.map{|a| a.receiver_id}

      #receiver have be assigned to another one, even not active, could not assigned, either
      others_assigned_ids = Assign.unsent.unexpired.uniq_receiver_ids.map{|a| a.receiver_id}

      #receiver if ever receive the photos by sender , dont assigns, either
      #Dont use the role right now, when startup, not too many users
      #[NOTICE]
      #sent_ids = self.sent_photos.uniq_receiver_ids.map{|p| p.receiver_id}

      assigned_sent_self_ids = assigned_ids.concat(others_assigned_ids).concat([self.id]).uniq

      #priority foreign country > same country
      user = if foreign_friend = User.diff_country(self.country_name).have_quota.not_assigned_or_sent_or_self(assigned_sent_self_ids).first(:order => 'rand()')
               foreign_friend
             elsif same_country_friend = User.same_country(self.country_name).have_quota.not_assigned_or_sent_or_self(assigned_sent_self_ids).first(:order => 'rand()')
               same_country_friend
             end

      # if user exist assign him/she to the current user
      self.assigned_receivers << user if user
      return user
    else
      return 'tolimit'
    end
  end

  def check_assign_and_change_quota(photo)
    #if this photo is for assigned job, check it and change quota
    if assigned = self.assigns.unexpired.unsent.where(:receiver_id => photo.receiver_id).first
      assigned.update_attributes(:sent_at => Time.now, :waiting_days => 0)
      #Sender increase one quota
      User.increment_counter(:receive_quota_now, self.id)
      #Receiver decrease one quota
      User.decrement_counter(:receive_quota_now, photo.receiver_id)
    end
  end

  #You could only share photos with some guy has been assigned to you or yourself ever be assigned to him
  def share_photo_permission(receiver)
    Assign.exists?(["(sender_id = ? AND receiver_id = ?) or (sender_id = ? AND receiver_id = ?)", self.id, receiver.id, receiver.id, self.id ])
  end

  #[TODO]
  #Maybe we could have one way to manual add special assigned user via email or a friend request confirmation

  private
  def init_user_quota
    self.send_quota_max = 3
    self.receive_quota_now = 1
  end

end
