class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Successfully created user."
      redirect_back_or_default root_path
    else
      render :action => 'new'
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated user."
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end

  def wall
    @user = User.find(params[:id])
    @receive_photos = @user.receive_photos.order("created_at DESC").include_receiver
    @sent_photos = @user.sent_photos.order("created_at DESC").include_sender
  end

  def assigned
    @users = current_user.assigned_receivers
  end
end
