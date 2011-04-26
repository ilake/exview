class AssignsController < ApplicationController
  before_filter :require_user

  def create
    @user = current_user.find_one_friend

    if @user.is_a?(User)
      flash.now[:notice] = "Meet a new friend #{@user.name}, you could share a photo to #{@user.name} now"
    end
    render :template => "users/show"
  end

end
