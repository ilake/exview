# -*- encoding : utf-8 -*-
class Notifier < ActionMailer::Base

  def password_reset_instructions(user)
    @edit_password_reset_url = edit_password_reset_url(user.perishable_token)
    mail(:to => named_email(user), :subject => "Password Reset Instructions")
  end

  #be sent after the user is actived
  def registration_confirmation(user)
    @account = user
    mail(:to => named_email(user), :subject => "Welcome")
  end

  def activation_instructions(user)
    @account_activation_url = activate_url(user.perishable_token)
    mail(:to => named_email(user), :subject => "Activation Instructions")
  end

  def photo_notification(param_photo, param_sender, param_receiver)
    @sender = param_sender
    @receiver = param_receiver
    @photo = param_photo
    mail(:to => named_email(param_receiver), :subject => "Photo Notification")
  end

  def message_notification(param_msg, param_sender, param_receiver)
    @sender = param_sender
    @receiver = param_receiver
    @msg = param_msg
    mail(:to => named_email(param_receiver), :subject => "Message Notification")
  end

  def comment_notification(user, param_comment)
    @comment = param_comment
    mail(:to => named_email(user), :subject => "Comment Notification")
#    mail(:bcc => users.map{|u| u.email}, :subject => "Comment Notification")
  end

  def assigned_user_notification(user, assigned_user)
    @account = user
    @assigned_account = assigned_user
    mail(:to => named_email(user), :subject => "Outcircle - introduce a friend for you")
  end

  private
  def named_email(user)
    "#{user.name} <#{user.email}>"
  end
end
