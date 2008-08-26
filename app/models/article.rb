class Article < ActiveRecord::Base
    
  FORMATTING_TYPES = ["HTML", "HAML", "Plain Text", "Syntaxi", "Textile", "Markaby"]
  
  # Mark this class taggable. 
  acts_as_taggable_on :tags
  
  # permalink_fu
  has_permalink :title
  
  # Validations
  validates_presence_of :title
  
  # Relationships
  has_many :comments, :dependent => :destroy, :order => "created_at ASC"
  belongs_to :user
  
  # Active record filters
  before_save :set_user_id
  after_save :clean_cached_pages
  
  def approved_comments
    Comment.find(:all, :conditions => ["article_id = ? AND approved = 1", self.id])
  end
  
  def approved_comments_count
    Comment.count(:conditions => ["article_id = ? AND approved = 1", self.id])
  end
  
  def self.find_all_by_date(options)
    # TODO: rewrite this cleaner!
    if options[:date] && options[:date][0]
      conditions = ["articles.published = ? AND year(published_date) = ?", true, options[:date][0]]
    else
      conditions = ["articles.published = ?", true]
    end
    @articles = Article.paginate :page => options[:page],
      :per_page => Settings.articles_per_page,
      :order => "published_date DESC",
      :conditions => conditions
  end
  
  
  def self.time_delta(year, month = nil, day = nil)
    from = Time.mktime(year, month || 1, day || 1)

    to = from.next_year
    to = from.next_month unless month.blank?
    to = from + 1.day unless day.blank?
    to = to - 1 # pull off 1 second so we don't overlap onto the next day
    return from..to
  end
  
  
  protected
  
  def set_user_id
    if User.current_user
      self.user_id = User.current_user.id
    end
  end
  
  def clean_cached_pages
    year_to_remove = self.published_date.year.to_s
    pages_to_remove = [year_to_remove, "articles", "index.html"]
    ### Callback to clean the cached pages ###
    cache_dir = RAILS_ROOT+"/public"
    pages_to_remove.each do |page|
      FileUtils.rm_rf(Dir.glob("#{cache_dir}/#{page}")) rescue Errno::ENOENT
      RAILS_DEFAULT_LOGGER.info("Cache '#{cache_dir}/#{page}' delete.")
    end
  end
  
end
