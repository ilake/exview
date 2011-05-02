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
    image_tag "http://chart.apis.google.com/chart?cht=map:fixed=-60,180,80,179&chs=550x360&chld=#{user.sent_countries}&chco=dbe1bf|ff0085|ff0085&chf=bg,s,99b3cc"
  end
  def live_google_map_chart(user)
    image_tag "http://chart.apis.google.com/chart?cht=map:fixed=-60,180,80,179&chs=550x360&chld=#{user.country_name}&chco=dbe1bf|ff0085|ff0085&chf=bg,s,99b3cc"
  end

  def human_country_name(country_code)
    ActionView::Helpers::FormOptionsHelper::COUNTRIES_HASH[country_code]
  end

  def wikipedia_url(country_code)
    "http://www.wikipedia.org/wiki/#{human_country_name(country_code)}"
  end

  def link_to_user_live(user)
    link_to human_country_name(user.country_name), wikipedia_url(user.country_name), :target => '_blank'
  end

  def link_to_user_hometown(user)
    link_to human_country_name(user.hometown_country_name), wikipedia_url(user.hometown_country_name), :target => '_blank'
  end

  def region_flag(region)
    raw "<span class='country #{region}'> <img title='' alt=''  src='http://static1.postcrossing.com/images/blank.gif'> </span>"
  end

  def facebook_like
    raw '<iframe src="http://www.facebook.com/plugins/like.php?href=http%3A%2F%2Fwww.outcircle.com%2F&amp;send=true&amp;layout=box_count&amp;width=60&amp;show_faces=true&amp;action=like&amp;colorscheme=light&amp;font&amp => eight=65" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:120px; height:65px;" allowTransparency="true"></iframe>'
  end

  def facebook_share
    raw '<a name="fb_share" type="button_count" href="http://www.facebook.com/sharer.php">Share</a><script src="http://static.ak.fbcdn.net/connect.php/js/FB.Share" type="text/javascript"></script>'
  end

  def twitter_button
    raw '<a href="http://twitter.com/share" class="twitter-share-button" data-count="vertical" data-via="weoutcircle">Tweet</a><script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>'
  end

  def facebook_fans_page
    raw '<iframe src="http://www.facebook.com/plugins/likebox.php?href=http%3A%2F%2Fwww.facebook.com%2Fpages%2FOutcircle%2F171655049556028&amp;width=292&amp;colorscheme=light&amp;show_faces=true&amp;stream=true&amp => eader=true&amp => eight=607" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:292px; height:607px;" allowTransparency="true"></iframe>'
  end

  HTTP_REGEX = /((http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/[A-Za-z\.0-9_\+\?%\/=&\-]*)?)/ix

  def full_format_content(content)
    c = content
    return 'Does not writing anything yet' if c.blank?

    return c.gsub(/\r\n/, "\n").gsub(/\n/) { |e|
      "<br />" unless $` =~/<br \/>$/
    }.gsub(HTTP_REGEX) do  |e|
      if $` =~/(href|src)=(?:"|')$/
        e
      else
        "<a href='#{e}'>#{e}</a>"
      end
    end
  end

  def google_analytics_script
    %{<script type="text/javascript">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-23078976-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })(); </script>}
  end
end
