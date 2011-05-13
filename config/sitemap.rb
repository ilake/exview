# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.outcircle.com"

SitemapGenerator::Sitemap.add_links do |sitemap|
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: sitemap.add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host

  #add welcome index
  sitemap.add root_path, :priority => 0.9

  #add about
  sitemap.add about_path, :priority => 0.9

  # add all individual use
  User.find_in_batches(:batch_size => 1000) do |users|
    users.each do |u|
      sitemap.add user_path(u), :priority => 0.7, :changefreq => 'daily'
    end
  end
end
