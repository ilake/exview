class AssignsController < ApplicationController
  before_filter :require_user

  def create
    @user = current_user.find_one_friend

    render :template => "users/show"
  end

end
