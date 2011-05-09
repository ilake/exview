# -*- encoding : utf-8 -*-
#ActionMailer::Base.smtp_settings = {
#  :address              => "smtp.gmail.com",
#  :port                 => 587,
#  :domain               => APP_CONFIG["mail_domain"],
#  :user_name            => APP_CONFIG["mail_account"],
#  :password             => APP_CONFIG["mail_pwd"],
#  :authentication       => "plain",
#  :enable_starttls_auto => true
#}

ActionMailer::Base.default_url_options[:host] = APP_CONFIG["mail_domain"]
ActionMailer::Base.default :from => APP_CONFIG["mail_from"]
Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
