class Notifier < ActionMailer::Base

  def registration_confirmation(user)
    @account = user
    mail(:to => named_email(user), :subject => "Registered")
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

  def comment_notification(users, param_comment)
    @comment = param_comment
    mail(:bcc => users.map{|u| u.email}, :subject => "Comment Notification")
  end

  private
  def named_email(user) 
    "#{user.name} <#{user.email}>" 
  end
end
