class WelcomeController < ApplicationController
  def index
    @photos = Photo.order("created_at DESC").limit(20).includes(:sender, :receiver)
    if current_user
      render :action => "user_index"
    end
  end

end
