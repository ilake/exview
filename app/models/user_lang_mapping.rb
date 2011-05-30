# == Schema Information
# Schema version: 20110526135515
#
# Table name: user_lang_mappings
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)
#  native_id   :integer(4)
#  practice_id :integer(4)
#

class UserLangMapping < ActiveRecord::Base
  belongs_to :user
  belongs_to :native_language, :class_name => 'Language', :foreign_key => :native_id
  belongs_to :practice_language, :class_name => 'Language', :foreign_key => :practice_id
end
