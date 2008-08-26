atom_feed(:url => formatted_article_url(:atom)) do |feed|
  feed.title(Settings.title)
  feed.description(Settings.subtitle)
  feed.updated(@articles.last ? @articles.last.published_date : Time.now.utc)

  for post in @articles
    feed.entry(post) do |xml|
      
      xml.title(post.title)
      xml.description(post.title)
      xml.content(print_formated(post.formatting_type, post.body), :type => 'html')
      xml.author(Settings.meta_content_author)               
      xml.pubDate(post.published_date.strftime("%a, %d %b %Y %H:%M:%S %z"))
      xml.published(post.published_date.strftime("%a, %d %b %Y %H:%M:%S %z"))
      xml.updated(post.published_date.strftime("%a, %d %b %Y %H:%M:%S %z"))
      xml.link(url_for(:id => post, :action => 'show', :controller => 'articles', :only_path => false, :protocol => 'http'))
      xml.guid(url_for(:id => post, :action => 'show', :controller => 'articles', :only_path => false, :protocol => 'http'))
      
      xml.author do |author|
        author.name(Settings.meta_content_author)
        author.email(Settings.email)
      end
    end
  end
end