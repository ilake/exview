# -*- encoding : utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
User.create!(:login => APP_CONFIG["admin_name"], :email => APP_CONFIG["admin_email"],
             :password => APP_CONFIG["admin_password"],
             :password_confirmation => APP_CONFIG["admin_password"],
             :receive_quota_now => 0, :send_quota_max => 0,
             :country_name => "TW", :hometown_country_name => "TW",
             :active => true)
