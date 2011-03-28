class MessagesController < ApplicationController
  before_filter :require_user
  
  def index
    if params[:mailbox] == "sent"
      @messages = current_user.sent_messages
    else
      @messages = current_user.received_messages
    end
  end
  
  def show
    @message = Message.read(params[:id], current_user)
  end
  
  def new
    @message = Message.new(:to => params[:to])

    if params[:reply_to]
      @reply_to = current_user.received_messages.find(params[:reply_to])
      unless @reply_to.nil?
        @message.to = @reply_to.sender.login
        @message.subject = "Re: #{@reply_to.subject}"
        @message.body = "\n\n*Original message*\n\n #{@reply_to.body}"
      end
    end
  end
  
  def create
    @message = Message.new(params[:message])
    @message.sender = current_user
    @message.recipient = User.find_by_login(params[:message][:to])

    if @message.save
      flash[:notice] = "Message sent"
      redirect_to user_messages_path(current_user)
    else
      render :action => :new
    end
  end
  
  def delete_selected
    if request.post?
      if params[:delete]
        params[:delete].each { |id|
          @message = Message.find(:first, :conditions => ["messages.id = ? AND (sender_id = ? OR recipient_id = ?)", id, current_user, current_user])
          @message.mark_deleted(current_user) unless @message.nil?
        }
        flash[:notice] = "Messages deleted"
      end
      redirect_to user_message_path(current_user, @messages)
    end
  end
  
end
