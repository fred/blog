module ArticlesHelper
  
  def link_to_permalink(article)
    year = article.published_date.year
    month = article.published_date.month
    day = article.published_date.day
    link = "/#{year}/#{month}/#{day}/#{article.permalink}"
  end
  
end
