class Notifier < ActionMailer::Base

  def registration_confirmation(user)
    @account = user
    mail(:to => user.email, :subject => "Registered")
  end

  def photo_notification(param_photo, param_sender, param_receiver)
    @sender = param_sender
    @receiver = param_receiver
    @photo = param_photo
    mail(:to => param_receiver.email, :subject => "Photo Notification")
  end

  def message_notification(param_msg, param_sender, param_receiver)
    @sender = param_sender
    @receiver = param_receiver
    @msg = param_msg
    mail(:to => param_receiver.email, :subject => "Message Notification")
  end

  def comment_notification(users, param_comment)
    @comment = param_comment
    mail(:bcc => users.map{|u| u.email}, :subject => "Comment Notification")
  end
end
