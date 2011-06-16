# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  include Facebooker2::Rails::Controller
  protect_from_forgery

  #helper :all
  before_filter :set_p3p_header_for_third_party_cookies
  helper_method :current_user, :current_user_session

  helper_method :human_country_name

  def human_country_name(country_code)
    ActionView::Helpers::FormOptionsHelper::COUNTRIES_HASH[country_code]
  end

  private

  def ensure_authenticated
    if current_facebook_user.nil?
      redirect_to root_url if  request.path != "/"
    else
      current_facebook_user.fetch

      email = current_facebook_user.email
      if user = User.find_by_email(email)
        user.facebook_id = current_facebook_user.id
      else
        user = User.find_or_initialize_by_facebook_id(current_facebook_user.id)
        user.email = email
      end

      user.login = current_facebook_user.name
      user.facebook_image = current_facebook_user.square_image_url
      user.active = true

      if user.new_record?
        user.password = current_facebook_user.first_name
        user.password_confirmation = user.password
      end
      user.save!
    end
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    elsif current_facebook_user and @current_user.nil?
      @current_user = User.find_by_facebook_id(current_facebook_user.id)
      session[:user_id] = @current_user.id
      @current_user
    end
  end

  def require_photo_watch_permission
    unless @photo.receiver.be_watched_photo_permission(current_user)
      flash[:notice] = "You are not friend with this photo owner yet, could not watch it"
      redirect_back_or_default(root_url)
    end
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to root_url
      return false
    end
  end

  def delayed_job_admin_authentication
    # authentication_logic_goes_here
    unless current_user.login == APP_CONFIG["admin_name"]
      redirect_to root_path
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def user_show_stuff
    if @user.be_watched_photo_permission(current_user)
      @receive_photos = @user.receive_photos.order("created_at DESC").include_sender.all
      @sent_photos = @user.sent_photos.order("created_at DESC").include_receiver.all
    end

    receive_countries = @user.receive_photos.group("from_country_name").count
    @receive_chart_regions = GoogleVisualr::GeoMap.new
    photo_world_map(@receive_chart_regions, receive_countries)

    sent_countries = @user.sent_photos.group("to_country_name").count
    @send_chart_regions = GoogleVisualr::GeoMap.new
    photo_world_map(@send_chart_regions, sent_countries)
  end

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

  def check_user_default_profile
    if current_user
      unless current_user.try(:country_name)
        redirect_to edit_user_path(current_user)
      end
    end
  end
end
