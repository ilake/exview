class AssignsController < ApplicationController
  before_filter :require_user

  def create
    @user = current_user.find_one_friend
    if @user.is_a?(User)
      flash.now[:notice] = "Meet a new friend [ #{@user.name} ], you could share a photo to #{@user.name} now"
      @receive_photos = @user.receive_photos.order("created_at DESC").include_sender.all
      @sent_photos = @user.sent_photos.order("created_at DESC").include_receiver.all

      render :template => "users/show"
    else
      @assigneds = current_user.assigns.unsent.unexpired.includes(:receiver)
      render :template => "users/not_found"
    end
  end

end
