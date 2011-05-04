class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @assigneds = current_user.assigns.unsent.unexpired.includes(:receiver) if @user.is_owner?(current_user)
    @receive_photos = @user.receive_photos.order("created_at DESC").include_sender.all
    @sent_photos = @user.sent_photos.order("created_at DESC").include_receiver.all

    receive_countries = @user.receive_photos.group("from_country_name").count
    @receive_chart_regions = GoogleVisualr::GeoMap.new
    photo_world_map(@receive_chart_regions, receive_countries)

    sent_countries = @user.sent_photos.group("to_country_name").count
    @send_chart_regions = GoogleVisualr::GeoMap.new
    photo_world_map(@send_chart_regions, sent_countries)

  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save_without_session_maintenance
      @user.deliver_activation_instructions!
      flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
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
      redirect_to current_user
    else
      render :action => 'edit'
    end
  end

  def assigned
    @assigneds = current_user.assigns.includes(:receiver)
  end

  def resend_activation
    if params[:login]
      @user = User.find_by_login params[:login]
      if @user && !@user.active?
        @user.deliver_activation_instructions!
        flash[:notice] = "Please check your e-mail for your account activation instructions!"
        redirect_to root_path
      end
    end
  end

#  def wall
#    @user = User.find(params[:id])
#    @receive_photos = @user.receive_photos.order("created_at DESC").include_receiver
#    @sent_photos = @user.sent_photos.order("created_at DESC").include_sender
#  end

  private
  def photo_world_map(chart_regions, countries)
    # Regions Example
    chart_regions.add_column('string'  , 'Country')
    chart_regions.add_column('number'  , 'Photos')
    chart_regions.add_rows(countries.size)
    countries.each_with_index do |kv, index|
      chart_regions.set_value(index, 0, human_country_name(kv[0]) );
      chart_regions.set_value(index, 1, kv[1] );
    end
    options = { :dataMode => 'regions' }
    options.each_pair do | key, value |
      chart_regions.send "#{key}=", value
    end
  end
end
