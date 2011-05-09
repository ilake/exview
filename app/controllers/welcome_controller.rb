# -*- encoding : utf-8 -*-
class WelcomeController < ApplicationController
  def index
    @photos = Photo.order("created_at DESC").limit(20).includes(:sender, :receiver)
  end

end
