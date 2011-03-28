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
end
