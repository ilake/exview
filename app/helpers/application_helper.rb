module ApplicationHelper
  def title(page_title, show_title = true)
    content_for(:title) { h(page_title.to_s) }
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def owner_page?(current_user, user)
    current_user == user
  end

  def link_to_user_profile(user)
    link_to user.name, user_path(user)
  end

  def link_to_user_wall(user)
    link_to user.name, wall_user_path(user)
  end

  def google_map_chart(countries_list)
    image_tag "http://chart.apis.google.com/chart?cht=map:fixed=-60,180,80,179&chs=600x360&chld=#{countries_list}&chco=dbe1bf|ff0085|ff0085&chf=bg,s,99b3cc"
  end

  def human_country_name(country_code)
    ActionView::Helpers::FormOptionsHelper::COUNTRIES_HASH[country_code] 
  end
end
