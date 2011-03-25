# == Schema Information
# Schema version: 20110323064406
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
#

class User < ActiveRecord::Base
  acts_as_authentic

  has_many :sent_photos, :class_name => 'Photo', :foreign_key => 'sender_id'
  has_many :receive_photos, :class_name => 'Photo', :foreign_key => 'receiver_id'

  def to_param
    "#{id}-#{login}"
  end

  def name
    login
  end

end
