# -*- encoding : utf-8 -*-
class PhotosController < ApplicationController
  before_filter :find_photo, :only => [:show, :edit, :update, :destroy]
  #Don't filter photo permission
  #before_filter :require_photo_watch_permission, :only => [:show]

  # GET /photos/1
  # GET /photos/1.xml
  def show
    @photo = Photo.find(params[:id])
    @comments = @photo.comments.includes(:user)
    @comment = @photo.comments.new

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @photo }
    end
  end

  # GET /photos/new
  # GET /photos/new.xml
  def new
    @receiver = User.find(params[:receiver_id])
    @photo = @receiver.receive_photos.new(:from_country_name => current_user.country_name)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @photo }
    end
  end

  # POST /photos
  # POST /photos.xml
  def create
    params[:photo][:avatar].try(:original_filename).try(:force_encoding, 'utf-8')

    @photo = current_user.sent_photos.new(params[:photo])
    current_user.check_assign_and_change_quota(@photo)

    respond_to do |format|
      if @photo.save
        format.html { redirect_to(user_path(@photo.receiver), :notice => 'Photo was successfully created.') }
        format.xml  { render :xml => @photo, :status => :created, :location => @photo }
      else
        @receiver = @photo.receiver
        format.html { render :action => "new" }
        format.xml  { render :xml => @photo.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
  def find_photo
    @photo = Photo.find(params[:id])
  end
end

#  # GET /photos
#  # GET /photos.xml
#  def index
#    @photos = Photo.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @photos }
#    end
#  end
#
#  # GET /photos/1/edit
#  def edit
#    @photo = Photo.find(params[:id])
#  end
#
#  # PUT /photos/1
#  # PUT /photos/1.xml
#  def update
#    @photo = Photo.find(params[:id])
#
#    respond_to do |format|
#      if @photo.update_attributes(params[:photo])
#        format.html { redirect_to(@photo, :notice => 'Photo was successfully updated.') }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @photo.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # DELETE /photos/1
#  # DELETE /photos/1.xml
#  def destroy
#    @photo.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(photos_url) }
#      format.xml  { head :ok }
#    end
#  end
#
