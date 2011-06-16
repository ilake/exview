# -*- encoding : utf-8 -*-
# == Schema Information
# Schema version: 20110616043146
#
# Table name: users
#
#  id                      :integer(4)      not null, primary key
#  login                   :string(255)     not null
#  email                   :string(255)     not null
#  gender                  :string(255)
#  speak                   :string(255)
#  memo                    :text
#  crypted_password        :string(255)     not null
#  password_salt           :string(255)     not null
#  persistence_token       :string(255)     not null
#  single_access_token     :string(255)     not null
#  perishable_token        :string(255)     not null
#  login_count             :integer(4)      default(0), not null
#  failed_login_count      :integer(4)      default(0), not null
#  last_request_at         :datetime
#  current_login_at        :datetime
#  last_login_at           :datetime
#  current_login_ip        :string(255)
#  last_login_ip           :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  country_name            :string(255)
#  send_quota_max          :integer(4)
#  receive_quota_now       :integer(4)
#  active                  :boolean(1)
#  hometown_country_name   :string(255)
#  sent_countries          :text
#  cached_slug             :string(255)
#  facebook_id             :string(255)
#  facebook_image          :string(255)
#  practice_languages_list :string(255)
#  native_languages_list   :string(255)
#

class User < ActiveRecord::Base
  attr_accessor :native_ids, :practice_ids
  acts_as_authentic
  has_private_messages
  has_friendly_id :login, :use_slug => true

  scope :diff_country, lambda {|country| where("country_name not in (?)", country)}
  scope :diff_hometown, lambda {|country| where("hometown_country_name not in (?)", country)}
  scope :same_country, lambda {|country| where("country_name = ?", country)}
  scope :have_quota, where("receive_quota_now > 0")
  scope :not_assigned_or_sent_or_self, lambda{|assigned_sent_ids| where("#{table_name}.id not in (?)", assigned_sent_ids)}
  scope :login_recently, order("last_login_at DESC")
  scope :receive_priority, order("receive_quota_now DESC")
  scope :is_active, where(:active =>  true)
  scope :fb_user, where("facebook_id is NOT NULL")

  has_many :sent_photos, :class_name => 'Photo', :foreign_key => 'sender_id'
  has_many :receive_photos, :class_name => 'Photo', :foreign_key => 'receiver_id'
  has_many :assigns, :class_name => 'Assign', :foreign_key => 'sender_id'
  has_many :assigned_receivers, :through => :assigns, :source => :receiver
  has_many :comments

  has_many :language_mappings, :class_name => 'UserLangMapping', :foreign_key => :user_id, :dependent => :destroy

  has_many :native_languages, :through => :language_mappings, :source => :native_language, :uniq => true
  has_many :practicing_languages, :through => :language_mappings, :source => :practice_language, :uniq => true

  before_create :init_user_quota
  after_update :init_user_lang_mapping

  def is_owner?(user)
    @is_owner ||= self == user
  end

  def name
    login
  end

  def self.find_by_login_or_email(login)
    find_by_login(login) || find_by_email(login)
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

      #Assigned priority foreign country(living) > same_country(but diffrent hometown) > same country(living)
      user = if foreign_friend = User.diff_country(self.country_name).have_quota.not_assigned_or_sent_or_self(assigned_sent_self_ids).is_active.receive_priority.login_recently.first
               foreign_friend
             elsif foreign_friend_in_your_country = User.diff_hometown(self.hometown_country_name).same_country(self.country_name).have_quota.not_assigned_or_sent_or_self(assigned_sent_self_ids).is_active.receive_priority.login_recently.first
               foreign_friend_in_your_country
             elsif same_country_friend = User.same_country(self.country_name).have_quota.not_assigned_or_sent_or_self(assigned_sent_self_ids).is_active.receive_priority.login_recently.first
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

      #Add the unique receive countries to sent_countries
      receiver_country_name = photo.receiver.country_name
      if self.sent_countries
        if !self.sent_countries.match(receiver_country_name)
          self.sent_countries = "#{self.sent_countries}|#{receiver_country_name}"
          self.save
        end
      else
        self.sent_countries = "#{receiver_country_name}"
        self.save
      end
    end
  end

  #You could only share photos with some guy has been assigned to you or yourself ever be assigned to him
  def share_photo_permission(receiver)
    Assign.exists?(["(sender_id = ? AND receiver_id = ?) or (sender_id = ? AND receiver_id = ?)", self.id, receiver.id, receiver.id, self.id ])
  end

  def be_watched_photo_permission(current_user)
    current_user && (self.is_owner?(current_user) || self.share_photo_permission(current_user))
  end

  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.activation_instructions(self).deliver
  end

  def deliver_welcome!
    reset_perishable_token!
    Notifier.registration_confirmation(self).deliver
  end

  def activate!
    self.active = true
    save
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.password_reset_instructions(self).deliver
  end

  def practice_languages_string
    practicing_languages.map{|l|l.name}.join('， ')
  end

  def native_languages_string
    native_languages.map{|l|l.name}.join('， ')
  end
  #[TODO]
  #Maybe we could have one way to manual add special assigned user via email or a friend request confirmation

  private
  def init_user_quota
    self.send_quota_max = APP_CONFIG["send_quota_max"] unless self.send_quota_max
    self.receive_quota_now = APP_CONFIG["receive_quota_default"] unless self.receive_quota_now
    self.sent_countries = "" unless self.sent_countries
    self.memo = "" unless self.memo
  end

  def init_user_lang_mapping
    if self.native_ids.present? || self.practice_ids.present?
      #User have language_mappings data
      practice_ids_array = practice_ids.values.uniq.delete_if{|v|v.blank?}
      native_ids_array = native_ids.values.uniq.delete_if{|v|v.blank?}

      original_language_mappings = self.language_mappings.map{|u| [u.native_id, u.practice_id]}.flatten.uniq!
      new_language_mappings = native_ids_array + practice_ids_array
      new_language_mappings.uniq!

      if original_language_mappings != new_language_mappings
        UserLangMapping.delete_all(:user_id => self.id)
        native_ids_array.each do |n_id|
          practice_ids_array.each do |p_id|
            UserLangMapping.create(:user_id => self.id, :native_id => n_id, :practice_id => p_id)
          end
        end
      end
      User.update_all({:practice_languages_list => practice_languages_string, :native_languages_list => native_languages_string}, :id => self.id)
    end
  end
end
