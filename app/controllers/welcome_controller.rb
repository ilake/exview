# -*- encoding : utf-8 -*-
class WelcomeController < ApplicationController
  before_filter :ensure_authenticated
  before_filter :check_user_default_profile

  def index
    @photos = Photo.order("created_at DESC").limit(20).includes(:sender, :receiver)
  end
end
