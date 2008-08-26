begin
  Settings.defaults[:theme] = "toader"
  Settings.defaults[:per_page] = 20
  Settings.defaults[:logo_title] = 'Site Title'
  Settings.defaults[:logo_subtitle] = "Site Subtitle"
  Settings.defaults[:meta_title] = "Meta Title"
  Settings.defaults[:meta_description] = "Meta Description"
  Settings.defaults[:site_copyrights] = 'Copyrights 2008'
  Settings.defaults[:email] = "admin@localhost"
  Settings.defaults[:content_keywords] = "ruby on rails, blog"
  Settings.defaults[:content_author] = "My Full Name"
  Settings.defaults[:google_analytics_key] = "UA-737604-xx"
  Settings.defaults[:site_email] = "info@localhost"
  Settings.defaults[:site_footer1] = "Footer Text1"
	Settings.defaults[:site_footer2] = "Footer Text2"
rescue => e
  puts "Please run pending migrations first. Settings table was not found"
end
  
