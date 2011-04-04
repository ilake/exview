class UserSession < Authlogic::Session::Base
  find_by_login_method :find_by_login_or_email

  def self.find_by_login_or_email(login)
    find_by_login(login) || find_by_email(login)
  end
end
