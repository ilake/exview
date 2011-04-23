amazon_creds = YAML::load(open("#{Rails.root}/config/app_config.yml"))
ActionMailer::Base.add_delivery_method :ses, AWS::SES::Base,
  :access_key_id     => amazon_creds['aws_access_key_id'],
  :secret_access_key => amazon_creds['aws_secret_access_key']
