module ApplicationHelper
  def title(page_title, show_title = true)
    content_for(:title) { h(page_title.to_s) }
    @show_title = show_title
  end

  def show_title?
    @show_title
  end


  def link_to_user_profile(user)
    link_to user.name, user_path(user)
  end

  def link_to_user_wall(user)
    link_to user.name, wall_user_path(user)
  end

  def friends_google_map_chart(user)
    image_tag "http://chart.apis.google.com/chart?cht=map:fixed=-60,180,80,179&chs=600x360&chld=#{user.sent_countries}&chco=dbe1bf|ff0085|ff0085&chf=bg,s,99b3cc"
  end
  def live_google_map_chart(user)
    image_tag "http://chart.apis.google.com/chart?cht=map:fixed=-60,180,80,179&chs=600x360&chld=#{user.country_name}&chco=dbe1bf|ff0085|ff0085&chf=bg,s,99b3cc"
  end

  def human_country_name(country_code)
    ActionView::Helpers::FormOptionsHelper::COUNTRIES_HASH[country_code]
  end

  def wikipedia_url(country_code)
    "http://www.wikipedia.org/wiki/#{human_country_name(country_code)}"
  end

end
