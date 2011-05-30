# == Schema Information
# Schema version: 20110526135515
#
# Table name: languages
#
#  id   :integer(4)      not null, primary key
#  name :string(255)
#

class Language < ActiveRecord::Base
  has_many :native_language_mappings, :class_name => 'UserLangMapping', :foreign_key => :native_id
  has_many :practicing_language_mappings, :class_name => 'UserLangMapping', :foreign_key => :practice_id

  has_many :native_languages_users, :through => :native_language_mappings, :source => :user, :uniq => true
  has_many :practicing_languages_users, :through => :practicing_language_mappings, :source => :user, :uniq => true

  def self.select_options
    @select_options ||= Language.all.collect {|p| [ p.name, p.id ] }
  end
end
